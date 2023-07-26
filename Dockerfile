FROM alpine:3

RUN apk add --update --no-cache socat bash

COPY *.sh /

RUN chmod +x /*.sh

ENTRYPOINT /entrypoint.sh
