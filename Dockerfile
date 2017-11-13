FROM alpine:latest
MAINTAINER Kevin Minehart <kmineh0151@gmail.com>

# install dependencies
RUN apk add --no-cache --update curl \
  bash \
  ca-certificates \
  wget \
  python2 \
  py2-openssl

RUN wget https://dl.google.com/dl/cloudsdk/channels/rapid/google-cloud-sdk.tar.gz
RUN tar -xvf google-cloud-sdk.tar.gz
RUN rm google-cloud-sdk.tar.gz
RUN google-cloud-sdk/install.sh --usage-reporting=false \
  --path-update=false \
  --bash-completion=false

RUN wget -qO- https://binaries.cockroachdb.com/cockroach-v1.1.1.linux-musl-amd64.tgz | tar  xvz
RUN cp -i cockroach-v1.1.1.linux-musl-amd64/cockroach /
RUN chmod +x /cockroach

# add backup script
COPY backup.sh /backup-cockroach
RUN chmod +x /backup-cockroach

CMD /backup-cockroach
