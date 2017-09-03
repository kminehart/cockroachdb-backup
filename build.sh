#!/usr/bin/env bash
wget -qO- https://binaries.cockroachdb.com/cockroach-latest.linux-musl-amd64.tgz | tar xvz

docker build . -t "kminehart/cockroachdb-backup:v1.0.5"
