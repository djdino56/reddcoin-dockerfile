# reddcoin-dockerfile
Dockerfile for Reddcoin 2.x on Linux

### Build Docker Image
    docker build -t reddcoin .
    
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
rpcallowip=127.0.0.1/16
rpcport=45443
port=
gen=0
server=1
staking=1
```

### Optional: Copy Wallet
    cp ~/.reddcoin/wallet.dat /var/run/reddcoin

**WARNING:** Always backup your wallet, as sudden termination of the container can cause corruption.

### Optional: Copy Bootstrap Data to Sync Faster
    cp ~/.reddcoin/bootstrap.dat /var/run/reddcoin

**OR**  

### Optional: Copy Existing Chain Data to Sync Even Faster
    cp -r ~/.reddcoin/database /var/run/reddcoin
    cp -r ~/.reddcoin/blocks /var/run/reddcoin
    cp -r ~/.reddcoin/chainstate /var/run/reddcoin

### Run Docker Container
    docker run \
      --detach \
      --publish 45443:8000 \
      --volume /var/run/reddcoin:/mnt/reddcoin \
      --name reddcoin-container \
      reddcoin


**NOTE:** Your wallet **must** be unlocked in order to participate in staking.
