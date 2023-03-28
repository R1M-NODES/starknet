#!/bin/bash

source <(curl -s https://raw.githubusercontent.com/R1M-NODES/utils/master/common.sh)
printLogo

read -p "Enter your Alchemy link (example: https://eth-goerli.alchemyapi.io/v2/secret): " ALCHEMY_KEY
sleep 1
echo 'export ALCHEMY_KEY='$ALCHEMY_KEY >> $HOME/.bash_profile

printGreen "Install dependencies"
sudo apt update
sudo apt install mc wget curl git htop net-tools unzip jq build-essential
ncdu tmux -y

printGreen "Install docker and docker compose"
bash <(curl -s https://raw.githubusercontent.com/R1M-NODES/utils/master/docker-install.sh)

git clone https://github.com/eqlabs/pathfinder.git
cd $HOME/pathfinder || exit
git fetch
VER=$(curl https://api.github.com/repos/eqlabs/pathfinder/releases/latest -s | jq .name -r)
git checkout $VER

source $HOME/.bash_profile
echo "PATHFINDER_ETHEREUM_API_URL=$ALCHEMY_KEY" > pathfinder-var.env

pringGreen "Spin up node"
docker compose pull
mkdir -p $HOME/pathfinder/pathfinder
chown -R 1000.1000 .
sleep 1
docker compose up -d

