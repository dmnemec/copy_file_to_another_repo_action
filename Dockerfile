FROM alpine

RUN apk update && \
    apk upgrade && \
    apk add git

ADD entrypoint.sh entrypoint.sh
RUN chmod +x entrypoint.sh

ENTRYPOINT [ "./entrypoint.sh" ]
