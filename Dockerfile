FROM alpine:3.10

### Disable Features From Base Image
ENV ENABLE_SMTP=false

### Create User
RUN addgroup spamassassin && \
    adduser -S \
               -D -G spamassassin \
               -h /var/lib/spamassassin/ \
           spamassassin && \

### Install Dependencies
       apk update && \
       apk add --no-cache \
               razor \
               spamassassin \
               && \
### Cleanup
       rm -rf /var/cache/apk/*

### Add Files
   ADD install /

### Networking Configuration
   EXPOSE 737
