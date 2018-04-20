#!/bin/bash -e

STAKING_INFO_JSON="$(reddcoin-cli -datadir=$REDDCOIN_DATA_DIR getstakinginfo)"
FILE_PATH="$REDDCOIN_DATA_DIR/stake_info_progression.csv"

# Fields
DATE="$(date +'%Y-%m-%d %H:%M:%S')"
BALANCE="$(reddcoin-cli -datadir=$REDDCOIN_DATA_DIR getbalance)"
STAKING=$(echo "${STAKING_INFO_JSON}" | jq '.staking')
DIFFICULTY=$(echo "${STAKING_INFO_JSON}" | jq '.difficulty')
AVG_WEIGHT=$(echo "${STAKING_INFO_JSON}" | jq '.averageweight')
TOTAL_WEIGHT=$(echo "${STAKING_INFO_JSON}" | jq '.totalweight')
NET_STAKE_WEIGHT=$(echo "${STAKING_INFO_JSON}" | jq '.netstakeweight')
EXPECTED_TIME=$(echo "${STAKING_INFO_JSON}" | jq '.expectedtime')

# Build CSV and append
if [ ! -f $FILE_PATH ]; then
  echo "Creating file for tracking stake info over time..."
  HEADER="DATE, BALANCE, STAKING, DIFFICULTY, AVG_WEIGHT, TOTAL_WEIGHT, NET_STAKE_WEIGHT, EXPECTED_TIME"
  echo $HEADER >> $FILE_PATH
fi
LINE="$DATE, $BALANCE, $STAKING, $DIFFICULTY, $AVG_WEIGHT, $TOTAL_WEIGHT, $NET_STAKE_WEIGHT, $EXPECTED_TIME"
echo $LINE >> $FILE_PATH
