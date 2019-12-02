FROM alpine:3.10

ENTRYPOINT [ "/init" ]

ARG S6_OVERLAY_RELEASE=v1.22.1.0
ENV S6_OVERLAY_RELEASE=${S6_OVERLAY_RELEASE}

ADD https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_RELEASE}/s6-overlay-amd64.tar.gz /tmp/s6overlay.tar.gz

### Disable Features From Base Image
ENV ENABLE_SMTP=false

### Create User
RUN addgroup spamassassin && \
  adduser -S \
  -D -G spamassassin \
  -h /var/lib/spamassassin/ \
  spamassassin && \
  apk update && \
  apk add --no-cache \
  razor \
  spamassassin \
  && tar xzf /tmp/s6overlay.tar.gz -C / \
  && rm /tmp/s6overlay.tar.gz \
  && rm -rf /var/cache/apk/*

COPY docker/spamassassin.sh /etc/services.d/spamassassing/run
COPY docker/config /assets/mail
RUN chmod a+x /etc/services.d/spamassassing/run
### Networking Configuration
EXPOSE 737
