#!/bin/bash -e
exec 2>/dev/null

TXID=$1
TRANSACTION_DATA="$(reddcoin-cli -datadir=$REDDCOIN_DATA_DIR gettransaction $TXID)"
STAKE_TIMESTAMP=$(echo "${TRANSACTION_DATA}" | jq '.timereceived')
STAKE_AMOUNT=$(echo "${TRANSACTION_DATA}" | jq '.fee')

if [ "${STAKE_TIMESTAMP}" -gt "0" ]; then
  DATE_FORMAT="%(%F %T)T\n"
  READABLE_DATE=$(printf "${DATE_FORMAT}" "${STAKE_TIMESTAMP}")
  echo "Staked ${STAKE_AMOUNT} RDD on $READABLE_DATE! [txid $TXID]"
fi
