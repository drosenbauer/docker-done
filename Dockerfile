FROM alpine:3

RUN apk add --update --no-cache socat bash

COPY --chmod=755 *.sh /

# Both ports are above 1024, so root isn't needed
USER nobody

ENTRYPOINT ["/entrypoint.sh"]
