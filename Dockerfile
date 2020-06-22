FROM debian:jessie-slim

# Install dependencies
RUN apt-get update && apt-get install -y \
  jq \
  wget \
  && rm -rf /var/cache/apk/*

# Download Reddcoin Core release https://download.reddcoin.com/bin/reddcoin-core-3.10.0/reddcoin-3.10.0-linux64.tar.gz
ENV REDDCOIN_VERSION 3.10.0
ENV REDDCOIN_PACKAGE reddcoin-$REDDCOIN_VERSION-linux64
ENV REDDCOIN_ARCHIVE $REDDCOIN_PACKAGE.tar.gz
ENV REDDCOIN_RELEASE https://download.reddcoin.com/bin/reddcoin-core-$REDDCOIN_VERSION/$REDDCOIN_ARCHIVE

ENV REDDCOIN_DIR /opt/$REDDCOIN_PACKAGE

# Download release and copy 64-bit binaries to /opt/reddcoin
WORKDIR /tmp
RUN wget $REDDCOIN_RELEASE
RUN tar -xzvf $REDDCOIN_ARCHIVE
RUN cd reddcoin-$REDDCOIN_VERSION \
  && mkdir -p $REDDCOIN_DIR/bin \
  && cp bin/* $REDDCOIN_DIR/bin \
  && rm -rf /tmp/reddcoin-$REDDCOIN_VERSION \
  && rm /tmp/$REDDCOIN_ARCHIVE

# Add to PATH
ENV PATH $REDDCOIN_DIR/bin:$PATH

ENV REDDCOIN_DATA_DIR /mnt/reddcoin
COPY data/ /mnt/reddcoin
# Copy scripts and set executable flag
COPY auto-stake.sh notify-stake.sh track-stake.sh /usr/bin/
RUN chmod +x /usr/bin/auto-stake.sh \
  && chmod +x /usr/bin/notify-stake.sh \
  && chmod +x /usr/bin/track-stake.sh

# Expose Reddcoin daemon RPC port
EXPOSE 45443

# Run the auto-stake script.
RUN mkdir -p /var/run/reddcoin
WORKDIR /var/run/reddcoin
ENTRYPOINT ["/usr/bin/auto-stake.sh"]
