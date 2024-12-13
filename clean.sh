#!/usr/bin/env bash

sudo setenforce 0

removeCA() {
  echo "Removing orderers "
  sudo docker compose -f ./create-certificate-with-ca/docker-compose.yaml down -v
}
removePeer() {
  echo "Removing orderers "
  sudo docker compose -f ./docker-compose.yaml down -v
}
removeExplorer() {
  echo "Removing explorer "
  sudo docker compose -f ./channel/explorer/docker-compose.yaml down -v
}
removeCA
removeExplorer
sudo docker compose -f ./docker-compose.yaml down -v

echo "Removing crypto CA material"
sudo rm -rf ./channel/channel-artifacts
sudo rm -rf ./channel/crypto-config
sudo rm -rf ./channel/deploy-chaincode/log.txt
sudo rm -rf ./channel/deploy-chaincode/basic.tar.gz
sudo rm -rf ./channel/src/go/vendor
sudo rm -rf ./channel/test-network
sudo rm -rf ./connection-profile/connection-org1.json
sudo rm -rf ./create-certificate-with-ca/fabric-ca
sudo rm -rf ./channel/explorer/examples