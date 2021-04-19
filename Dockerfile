FROM jaxa/p4c-epoch
MAINTAINER Seth Fowler <seth@barefootnetworks.com>
MAINTAINER Robert Soule <robert.soule@barefootnetworks.com>

# Install dependencies and some useful tools.
ENV NET_TOOLS iputils-arping \
              iputils-ping \
              iputils-tracepath \
              net-tools \
              nmap \
              python3-pip \
              python3-dev \
              tcpdump \
              traceroute \
              tshark \
              bridge-utils
ENV MININET_DEPS automake \
                 build-essential \
                 cgroup-bin \
                 ethtool \
                 gcc \
                 help2man \
                 iperf \
                 iproute \
                 libtool \
                 make \
                 pkg-config \
                 psmisc \
                 socat \
                 ssh \
                 sudo \
                 telnet \
                 pep8 \
                 pyflakes \
                 pylint \
                 python3-pexpect \
                 python3-setuptools

# Ignore questions when installing with apt-get:
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y -o Dpkg::Options::='--force-confdef' --no-install-recommends $NET_TOOLS $MININET_DEPS

# Fix to get tcpdump working
RUN mv /usr/sbin/tcpdump /usr/bin/tcpdump

RUN pip install ipaddr scapy psutil
RUN pip install influxdb
RUN apt-get install -y nano
# Install mininet.
COPY docker/third-party/mininet /third-party/mininet
WORKDIR /third-party/mininet
RUN cp util/m /usr/local/bin/m
RUN make install && \
    rm -rf /third-party/mininet
# Install the scripts we use to run and test P4 apps.
COPY docker/scripts /scripts
WORKDIR /scripts

ENTRYPOINT ["./p4apprunner.py"]
