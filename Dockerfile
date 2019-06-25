FROM alpine:3.10

RUN apk add --update --no-cache netcat-openbsd bash

COPY *.sh /

RUN chmod +x /*.sh

ENTRYPOINT /entrypoint.sh
