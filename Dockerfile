FROM scratch

ADD main /bin/action

ENTRYPOINT [ "/bin/action" ]
