FROM python:3

RUN apt-get -y update \
    && apt-get -y install vsftpd inetutils-ftp \
    && apt-get -y install libpcap0.8 \
    && pip install scapy

WORKDIR /usr/src/app

COPY . .

# Default command to keep the container active
# CMD ["tail", "-f", "/dev/null"]
CMD service vsftpd start && tail -f /dev/null
