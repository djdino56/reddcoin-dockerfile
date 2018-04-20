FROM debian:jessie-slim
MAINTAINER Erik Rogers <erik.rogers@live.com>

# Install dependencies
RUN apt-get update && apt-get install -y \
  jq \
  wget \
  && rm -rf /var/cache/apk/*

# Download Reddcoin Core release
ENV REDDCOIN_VERSION 2.0.1.2
ENV REDDCOIN_PACKAGE reddcoin-$REDDCOIN_VERSION-linux
ENV REDDCOIN_ARCHIVE $REDDCOIN_PACKAGE.tar.gz
ENV REDDCOIN_RELEASE https://github.com/reddcoin-project/reddcoin/releases/download/v$REDDCOIN_VERSION/$REDDCOIN_ARCHIVE

ENV REDDCOIN_DIR /opt/$REDDCOIN_PACKAGE

# Download release and copy 64-bit binaries to /opt/reddcoin
WORKDIR /tmp
RUN wget $REDDCOIN_RELEASE \
  && tar -xzvf $REDDCOIN_ARCHIVE \
  && cd $REDDCOIN_PACKAGE \
  && mkdir -p $REDDCOIN_DIR/bin \
  && cp bin/64/* $REDDCOIN_DIR/bin \
  && rm -rf /tmp/$REDDCOIN_PACKAGE \
  && rm /tmp/$REDDCOIN_ARCHIVE

# Add to PATH
ENV PATH $REDDCOIN_DIR/bin:$PATH

ENV REDDCOIN_DATA_DIR /mnt/reddcoin

# Copy scripts and set executable flag
COPY auto-stake.sh notify-stake.sh /usr/bin/
RUN chmod +x /usr/bin/auto-stake.sh \
  && chmod +x /usr/bin/notify-stake.sh \
  && chmod +x /usr/bin/track-stake.sh

# Expose Reddcoin daemon RPC port
EXPOSE 45443

# Run the auto-stake script.
RUN mkdir -p /var/run/reddcoin
WORKDIR /var/run/reddcoin
ENTRYPOINT ["/usr/bin/auto-stake.sh"]
