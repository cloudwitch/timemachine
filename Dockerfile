FROM debian:latest AS builder

ENV DEBIAN_FRONTEND="noninteractive"

RUN echo "Updating and installing dependancies of build container" &&\
  apt-get update &&\
  apt-get -y full-upgrade &&\
  apt-get -y install build-essential \
  devscripts \
  debhelper \
  cdbs \
  autotools-dev \
  dh-buildinfo \
  libdb-dev \
  libwrap0-dev \
  libpam0g-dev \
  libcups2-dev \
  libkrb5-dev \
  libltdl3-dev \
  libgcrypt11-dev \
  libcrack2-dev \
  libavahi-client-dev \
  libldap2-dev \
  libacl1-dev \
  libevent-dev \
  d-shlibs \
  dh-systemd \
  git \
  figlet &&\
  echo "Cloning netalk repo" &&\
  echo "https://techsmix.net/timemachine-backups-debian-8-jessi/" &&\
  git clone  https://github.com/adiknoth/netatalk-debian &&\
  cd netatalk-debian &&\
  figlet "Compiling" &&\
  debuild -b -uc -us &&\
  ls -alh &&\
  figlet "Starting Build"


FROM pheonix991/debian-9-baseimage:latest

ENV DEBIAN_FRONTEND="noninteractive"

COPY --from=builder /libatalk*_*-1_amd64.deb /installfiles/
COPY --from=builder /netatalk_*-1_amd64.deb /installfiles/
COPY --from=builder /libatalk18-dbgsym_*-1_amd64.deb /installfiles/
COPY root/ /

RUN apt-get update &&\
  apt-get -y full-upgrade &&\
  apt-get -y install procps \
  libwrap0 \
  libldap-common \
  libcrack2 \
  avahi-daemon \
  libavahi-client3 \
  libldap-common \
  slapd libevent-dev \
  python &&\
  cd /installfiles/ &&\
  dpkg -i libatalk18_3.*-1_amd64.deb netatalk_*-1_amd64.deb &&\
  apt-get -y autoremove && \
  apt-get clean && \
  cd / \
  rm -rf /var/lib/apt/lists/ /installfiles &&\
  touch /var/log/netatalk.log

EXPOSE 548 636

VOLUME ["/timemachine", "/config"]

CMD [ "tail", "-f", "/var/log/netatalk.log" ]
