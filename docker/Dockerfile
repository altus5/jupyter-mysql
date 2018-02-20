FROM jupyter/base-notebook:latest

RUN pip install pandas matplotlib ipython-sql

# jupyterコンテナには python3 が使われている
# python3 で ipython-sql を使うには、libmysqlclient-dev が必要
USER root
RUN sudo sed -i'~' -E "s@http://(..\.)?(archive|security)\.ubuntu\.com/ubuntu@http://ftp.jaist.ac.jp/pub/Linux/ubuntu@g" /etc/apt/sources.list
RUN apt-get update && apt-get install -y \
  build-essential \
  libmysqlclient-dev \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
RUN pip install mysqlclient
USER jovyan

# winpty docker run -ti --rm -p 8888:8888 -v /$(pwd)://home/jovyan/work jupyter/base-notebook:latest
