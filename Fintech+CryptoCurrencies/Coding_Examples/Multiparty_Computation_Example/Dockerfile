FROM python:3.7

RUN  apt-get update -y && \
     apt-get upgrade -y

# API
RUN mkdir -p /usr/src
COPY app.py /usr/src/app.py
COPY requirements.txt /usr/src/requirements.txt

WORKDIR /usr/src

RUN pip install -r requirements.txt

ENV QUART_APP=app:app
ENV QUART_ENV=development

# Start processes
CMD ["quart", "run"]