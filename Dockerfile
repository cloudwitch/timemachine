FROM debian:latest AS builder

RUN echo "Updating and installing dependancies of build container" &&\
  apt-get update &&\
#  apt-get -y full-upgrade &&\
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
  git &&\
  echo "Cloning netalk repo" &&\
  echo "https://techsmix.net/timemachine-backups-debian-8-jessi/" &&\
  git clone  https://github.com/adiknoth/netatalk-debian &&\
  cd netatalk-debian &&\
  echo "Compiling " &&\
  debuild -b -uc -us


FROM debian:latest

RUN apt-get update &&\
  apt-get -y full-upgrade &&\
  mkdir /installfiles



COPY --from=builder /libatalk-dev_*-1_amd64.deb /installfiles/
COPY --from=builder /libatalk18-dbgsym_*-1_amd64.deb /installfiles/
COPY --from=builder /libatalk18_*-1_amd64.deb /installfiles/
COPY --from=builder /netatalk-dbgsym_*-1_amd64.deb /installfiles/
COPY --from=builder /netatalk_*-1_amd64.build /installfiles/
COPY --from=builder /netatalk_*-1_amd64.deb /installfiles/

RUN ls -al /installfiles