FROM pheonix991/alpine-baseimage:latest

COPY root/ /

RUN apk add --no-cache netatalk &&\
  touch /netatalk.log &&\
  touch /var/netatalk/afp_signature.conf &&\
  mkdir /timemachine &&\
  chmod 777 /var/lock /var/netatalk/afp_signature.conf

EXPOSE 548 636

VOLUME ["/timemachine", "/config"]

CMD [ "tail", "-f", "/netatalk.log" ]
