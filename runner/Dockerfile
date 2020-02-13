FROM ubuntu:18.04

RUN apt-get update
RUN apt-get install -y build-essential make flex bison 
RUN apt-get install -y sharutils unzip

RUN useradd -M -u 1337 -U -s /bin/nologin compiler
RUN useradd -M -u 31337 -U -s /bin/nologin runner

COPY init.sh /
COPY bins/* /usr/local/bin/
