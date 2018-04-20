# reddcoin-dockerfile
Dockerfile for Reddcoin Core 2.0 Daemon + Staking on Linux (Debian)

:moneybag: Donations welcomed at `RkXmtTHthn3MNVMS6m9kzdzunVdTt9fjpv` :bow:

## Build

### Build Docker Image (Debian)
    docker build -t reddcoin .
   
### Build Docker Image (Raspberry Pi)
    docker build -t reddcoin -f Dockerfile-rpi .
    
### Create Data Directory
    mkdir -p /var/run/reddcoin

### Create `reddcoin.conf` Configuration File
    cd /var/run/reddcoin
    touch ./reddcoin.conf
    nano ./reddcoin.conf
    
*Example:*
```
rpcuser=reddcoinrpc
rpcpassword=Super$ecretPassw0rd!
rpcallowip=172.17.0.0/16
rpcport=45443
port=
gen=0
server=1
staking=1
```

**NOTE:** You should **not** modify the `rpcallowip=172.17.0.0/16` line if you are running `reddcoind` inside a Docker container! This is the subnet that the Docker `bridge0` interface uses to expose containers to the host.

### Optional: Copy Wallet
    cp ~/.reddcoin/wallet.dat /var/run/reddcoin

**WARNING:** Always backup your wallet, as sudden termination of the container can cause corruption.

### Optional: Copy Existing Chain Data to Sync Even Faster
    cp -r ~/.reddcoin/blocks /var/run/reddcoin
    cp -r ~/.reddcoin/chainstate /var/run/reddcoin

## Run
    
### Run Docker Container
    docker run \
      --detach \
      --publish 45443:45443 \
      --volume /var/run/reddcoin:/mnt/reddcoin \
      --env WALLET_PASSPHRASE=your_wallet_passphrase \
      --name reddcoin-container \
      reddcoin
      
**NOTE:** Your wallet will automatically be unlocked and start staking when the container is run. It is important that your wallet passphrase is set correctly (above) in order for this to work properly.

### Subsequent runs

You can save some time by disabling the rescan after you've successfully used an imported wallet. Scenarios where this might apply is if you need to restart the container, or build a new container that will use the same data directory.
    
    docker run \
      ...
      --env REDDCOIN_RESCAN=false
      ...

## Logging

### Staking Info Progression

One might find the progression of their staking info (and balance) interesting. A CSV file is created and periodically updated with staking info.

|DATE|BALANCE|STAKING|DIFFICULTY|AVG_WEIGHT|TOTAL_WEIGHT|NET\_STAKE_WEIGHT|EXPECTED_TIME|
|---|---|---|---|---|---|---|---|                                                                   
2018-04-01 00:31:26|1000|true|164.31246572|1128271|1128271|11761944443|625485
2018-04-01 01:31:26|1005|true|164.31927620|11128271|11128271|11761944443|4525485

### Tail Container Logs
    docker logs -f reddcoin-container
