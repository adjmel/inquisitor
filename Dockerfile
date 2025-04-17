FROM python:3

RUN apt-get -y update \
    && apt-get -y install vsftpd inetutils-ftp \
    && apt-get -y install libpcap0.8 \
    && pip install scapy

WORKDIR /usr/src/app

COPY . .

CMD service vsftpd start && tail -f /dev/null
