FROM debian:jessie-backports

LABEL maintainer="Marcelo Almeida <marcelo.almeida@jumia.com>"

WORKDIR "/root"

ENV DEBIAN_FRONTEND noninteractive
ENV \
  VERSION=3.8.2 \
  ARCH=amd64

# INSTALL BUILDER DEPENDENCIES
RUN apt-get update && apt-get install -y --no-install-recommends \
  curl \
  ca-certificates

COPY src /root/build/

# CREATE PACKAGE
RUN \
  mkdir -p build/usr/lib/ && \
  curl -s -L http://www.libxl.com/download/libxl-lin-${VERSION}.tar.gz | tar xvz && \
  cp libxl-*/lib64/libxl.so build/usr/lib/ && \
  mv build libxl_${VERSION}-1_${ARCH} && \
  dpkg-deb --build libxl_${VERSION}-1_${ARCH}
  
VOLUME ["/pkg"]
