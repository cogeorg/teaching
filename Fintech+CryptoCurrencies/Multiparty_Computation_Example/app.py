import asyncio
import json
import os
import random

import aiohttp
from aiohttp import ClientSession
from quart import Quart, request

PORT = os.getenv('PORT')

PARTIES = []
NUM_PARTIES = 0

collected_shares = {}
collected_sums = {}

app = Quart(__name__)

async def load(request):
  request_data = await request.data
  return json.loads(request_data)

def create_shares(secret, n):
  shares = [int(random.uniform(-1,1)*10**16) for i in range(n-1)]
  share_n = secret - sum(shares)
  shares.append(share_n)
  return shares

async def fetch(session, url, method, **kwargs):
  resp = await session.request(method=method, url=url, **kwargs)
  t = await resp.text()
  return json.loads(t)

def check_setup(data_id):
  if not PARTIES:
      return {'ERROR': 'Members have not been set yet.'}
  if len(collected_shares.get(data_id, [])) == NUM_PARTIES:
      return {'ERROR': 'This data id has already been used.'}
  return False

async def compute(data):
  secret = int(data['data'])
  shares = create_shares(secret, NUM_PARTIES)
  for i, party in enumerate(PARTIES):
    async with ClientSession() as session:
      await fetch(session, party + '/share', 'POST', data=json.dumps({'share':shares[i], 'data_id': data['data_id']}))
  return True

async def wait_for_it(data_id):
  while len(collected_sums.get(data_id, [])) < NUM_PARTIES:
    await asyncio.sleep(1)
  return True

@app.route('/members', methods=['POST'])
async def set_members():
  global PARTIES, NUM_PARTIES
  if not PARTIES:
    data = await load(request)
    PARTIES = data['members']
    NUM_PARTIES = len(PARTIES)
    return json.dumps({'parties': PARTIES, 'num_parties': NUM_PARTIES})
  else:
    return json.dumps({'ERROR': 'Members have already been set.'}), 409

@app.route('/compute-average', methods=['POST'])
async def compute_average():
  data = await load(request)
  error = check_setup(data['data_id'])
  if error:
    return json.dumps(error), 409
  await compute(data)
  await wait_for_it(data['data_id'])
  result = sum(collected_sums[data['data_id']]) / NUM_PARTIES
  return json.dumps(result)

@app.route('/share', methods=['POST'])
async def share():
  data = await load(request)
  data_id = data['data_id']
  if len(collected_shares.get(data_id, [])) == NUM_PARTIES:
    return json.dumps({'ERROR': 'This data id has already been completely processed.'}), 409
  else:
    if not collected_shares.get(data_id, []):
      collected_shares[data_id] = [int(data['share'])]
    else:
      collected_shares[data_id].append(int(data['share']))
      if len(collected_shares[data_id]) == NUM_PARTIES:
        result = sum(collected_shares[data_id])
        for party in PARTIES:
          async with ClientSession() as session:
            await fetch(session, party + '/sum', 'POST', data=json.dumps({'sum': result, 'data_id': data_id}))
    return json.dumps(True)

@app.route('/sum', methods=['POST'])
async def _sum():
  data = await load(request)
  data_id = data['data_id']
  if len(collected_sums.get(data_id, [])) == NUM_PARTIES:
    return json.dumps({'ERROR': 'This data id has already been completely processed.'}), 409
  else:
    if not collected_sums.get(data_id, []):
      collected_sums[data_id] = [int(data['sum'])]
    else:
      collected_sums[data_id].append(int(data['sum']))
    return json.dumps(True)


app.run(host='0.0.0.0', port=PORT)