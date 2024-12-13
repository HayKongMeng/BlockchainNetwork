#!/bin/bash

sleep 1s

cd channel || exit 1 
./start-all.sh || exit 1  


sleep 2s
echo
echo "Starting material..."
sleep 5s  


cd src/go || exit 1

# Initialize Go modules for chaincode
echo "Setting up Go modules for chaincode..."

# Check if go.mod exists
if [ ! -f go.mod ]; then
    go mod init chaincode || exit 1  
fi

# Always run go mod tidy
go mod tidy || exit 1 

sleep 5s

echo
echo "Deploying chaincode..."
cd ../../deploy-chaincode || exit 1 
./deploy-chaincode.sh || exit 1 

cd ../.. || exit 1
cd channel/explorer || { echo "Failed to navigate to channel/explorer"; exit 1; }
docker compose up -d || { echo "Failed to start Docker containers"; exit 1; }

sleep 5s
cd ../.. || exit 1
cd connection-profile || { echo "Failed to navigate to connection-profile"; exit 1; }
./generate-ccp.sh || { echo "Failed to execute generate-ccp.sh"; exit 1; }

echo "Explorer is up and running!"
echo "Setup successful!"