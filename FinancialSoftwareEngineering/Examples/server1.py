import asyncio
import time
import sys
import random


async def listen_to_connections(n: int):
    print(f"listen: sleep({n:0.0f})")
    await asyncio.sleep(n)


async def main(*args):
    await asyncio.gather(
        listen_to_connections(2)
    )


if __name__ == "__main__":
    args = []
    start = time.perf_counter()
    asyncio.run(main(*args))
    end = time.perf_counter() - start
    print(f"Run time: {end:0.2f}s")
