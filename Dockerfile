# Based on Michael Lynch's Sia on Docker Guide (https://mtlynch.io/sia-via-docker/)
FROM debian:jessie-slim
MAINTAINER Erik Rogers <erik.rogers@live.com>

ENV REDDCOIN_VERSION 2.0.0.0
ENV REDDCOIN_PACKAGE reddcoin-$REDDCOIN_VERSION-linux
ENV REDDCOIN_ARCHIVE ${REDDCOIN_PACKAGE}.tar.gz

# Choose a binary release of Reddcoin.
ENV REDDCOIN_RELEASE https://github.com/reddcoin-project/reddcoin/releases/download/v$REDDCOIN_VERSION/$REDDCOIN_ARCHIVE
# Choose the directory within the container where Docker will place Reddcoin.
ENV REDDCOIN_DIR /opt/$REDDCOIN_PACKAGE

RUN apt-get update && apt-get install -y \
  socat \
  wget \
  && rm -rf /var/cache/apk/*

# Download and install Reddcoin.
WORKDIR /opt
RUN wget $REDDCOIN_RELEASE \
  && tar -xvzf $REDDCOIN_ARCHIVE \
  && rm $REDDCOIN_ARCHIVE

# Make the Reddcoin ports available to the Docker container (--publish 45443:8000 from host).
EXPOSE 8000

# Configure the Reddcoin daemon to run when the container starts
# Forward 8000 to localhost:45443 so it's accessible outside the container.
# Specify the Reddcoin directory as /mnt/reddcoin so that you can view these files outside
# of Docker.
WORKDIR $REDDCOIN_DIR
ENTRYPOINT socat tcp-listen:8000,reuseaddr,fork tcp:localhost:45443 & ./bin/64/reddcoind -datadir=/mnt/reddcoin
