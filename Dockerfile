FROM python:alpine
ENV PYTHONUNBUFFERED=1
# dependencies to make postgres work on alpine python
# RUN apk update && apk add postgresql-dev gcc python3-dev musl-dev

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" > /etc/apk/repositories
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories


RUN apk update
RUN apk add chromium
RUN apk add chromium-chromedriver


RUN apk add --update --no-cache python3-dev \
                        gcc \
                        libc-dev \
                        libffi-dev
RUN apk add --update --no-cache postgresql-client jpeg-dev
RUN apk add --update --no-cache --virtual .tmp-build-deps \
    gcc libc-dev linux-headers postgresql-dev musl-dev zlib zlib-dev
RUN apk add --update --no-cache g++ gcc libxslt-dev
WORKDIR /code
COPY requirements-dev.txt requirements-dev.txt
RUN python -m pip install --upgrade pip
RUN pip3 install --upgrade pip setuptools wheel

RUN apk update && apk add build-base libzmq musl-dev python3 python3-dev zeromq-dev
RUN pip3 install -r requirements-dev.txt
RUN pip3 install torch==1.9.0+cpu torchvision==0.10.0+cpu torchaudio==0.9.0 -f https://download.pytorch.org/whl/torch_stable.html
RUN apk del .tmp-build-deps
COPY . /code/