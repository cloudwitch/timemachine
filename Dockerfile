FROM pheonix991/alpine-baseimage:latest

COPY root/ /

RUN apk add --no-cache netatalk &&\
  touch /netatalk.log &&\
  mkdir /timemachine

EXPOSE 548 636

VOLUME ["/timemachine", "/config"]

CMD [ "tail", "-f", "/netatalk.log" ]
