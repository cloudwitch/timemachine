FROM pheonix991/alpine-baseimage:latest

COPY root/ /

RUN apk add --no-cache netatalk &&\
  touch /var/log/netatalk.log

EXPOSE 548 636

VOLUME ["/timemachine", "/config"]

CMD [ "tail", "-f", "/var/log/netatalk.log" ]
