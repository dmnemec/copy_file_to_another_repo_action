FROM mirror.gcr.io/library/alpine:3.15

RUN apk update && \
    apk upgrade && \
    apk add git rsync

ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
