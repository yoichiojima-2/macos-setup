FROM python:latest

COPY requirements.txt /tmp/requirements.txt

RUN pip install --upgrade pip
RUN pip install -r /tmp/requirements.txt

WORKDIR /home

CMD ["ipython"]
