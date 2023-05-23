#!/bin/bash
exists()
{
  command -v "$1" >/dev/null 2>&1
}
if exists curl; then
echo ''
else
  sudo apt update && sudo apt install curl -y < "/dev/null"
fi
bash_profile=$HOME/.bash_profile
if [ -f "$bash_profile" ]; then
    . $HOME/.bash_profile
fi
IPADDR=$(curl IFCONFIG.ME)
SUGGESTED_FEE_RECIPIENT='0x2fF53aeC1Ac58b9691B22Be6cD8bad338b2F6ce8'
sleep 1
echo -e "███████╗ █████╗ ███╗   ██╗ ██████╗ ██╗  ████████╗";
echo -e "██╔════╝██╔══██╗████╗  ██║██╔════╝ ██║  ╚══██╔══╝";
echo -e "███████╗███████║██╔██╗ ██║██║  ███╗██║     ██║";
echo -e "╚════██║██╔══██║██║╚██╗██║██║   ██║██║     ██║";
echo -e "███████║██║  ██║██║ ╚████║╚██████╔╝███████╗██║";
echo -e "╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚══════╝╚═╝";
sleep 1

sudo apt update && sudo apt install chrony wget make clang pkg-config libssl-dev build-essential git jq ncdu bsdmainutils htop -y
#install go
VERSION=1.20.3
wget -O go.tar.gz https://go.dev/dl/go$VERSION.linux-amd64.tar.gz
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go.tar.gz && rm go.tar.gz
echo 'export GOROOT=/usr/local/go' >> $HOME/.bash_profile
echo 'export GOPATH=$HOME/go' >> $HOME/.bash_profile
echo 'export GO111MODULE=on' >> $HOME/.bash_profile
echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> $HOME/.bash_profile && . $HOME/.bash_profile
go version
#install geth
#go install github.com/ethereum/go-ethereum/cmd/geth@latest
cd $HOME && rm -rf go-ethereum
git clone https://github.com/ethereum/go-ethereum.git
cd go-ethereum
make geth
mv ./build/bin/geth /usr/local/bin/


sudo tee /etc/systemd/system/geth.service<<EOF
[Unit]
Description=Geth Execution Layer Client service
After=network.target

[Service]
User=$USER
Type=simple
RestartSec=3
TimeoutSec=300
Restart=on-failure
LimitNOFILE=65535
ExecStart=/usr/local/bin/geth --goerli \
--ws --ws.addr 0.0.0.0 --ws.port 8546 --ws.origins '*' --ws.api eth,net,web3 \
--http --metrics --pprof --authrpc.addr localhost --authrpc.port 8551 --authrpc.vhosts localhost \
--authrpc.jwtsecret /tmp/jwtsecret

[Install]
WantedBy=multi-user.target
EOF
sudo tee <<EOF >/dev/null /etc/systemd/journald.conf
Storage=persistent
EOF

sudo systemctl daemon-reload
sudo systemctl enable geth
sudo systemctl restart geth

sleep 5
#install beacon chain
cd $HOME
mkdir $HOME/prysm && cd $HOME/prysm
curl https://raw.githubusercontent.com/prysmaticlabs/prysm/master/prysm.sh --output prysm.sh && sudo chmod +x prysm.sh

sudo tee /etc/systemd/system/beacon-chain.service<<EOF
[Unit]
Description=eth consensus layer beacon chain service
Wants=network-online.target
After=network-online.target

[Service]
Type=simple
User=ubuntu
Restart=on-failure
ExecStart=/home/ubuntu/prysm/prysm.sh beacon-chain \
  --goerli \
  --checkpoint-sync-url=https://goerli.beaconstate.info \
  --genesis-beacon-api-url=https://goerli.beaconstate.info \
  --execution-endpoint=http://localhost:8551 \
  --jwt-secret=/tmp/jwtsecret \
  --suggested-fee-recipient= $SUGGESTED_FEE_RECIPIENT\
  --accept-terms-of-use \
  --grpc-gateway-host 0.0.0.0

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable beacon-chain
sudo systemctl restart beacon-chain
sleep 5

if [[ `service geth status | grep active` =~ "running" ]]; then
  echo -e "Your Geth node installed and works!"
  echo -e "You can check node status by the command \e[7msystemctl status geth\e[0m"
  echo -e "Press \e[7mQ\e[0m for exit from status menu"
else
  echo -e "Your Geth node was not installed correctly, please reinstall."
fi
if [[ `service beacon-chain status | grep active` =~ "running" ]]; then
  echo -e "Your Beacon-chain node installed and works!"
  echo -e "You can check node status by the command \e[7msystemctl status beacon-chain\e[0m"
  echo -e "Press \e[7mQ\e[0m for exit from status menu"
else
  echo -e "Your Beacon-chain node was not installed correctly, please reinstall."
fi

echo -e "Your BeaconNodeAddr http://$IPADDR:3500"
echo -e "Your ETH1 Websocket ws://$IPADDR:8546"