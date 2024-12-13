# Variables
peer0=peer0.org1.ownify.com
chaincode_path=../src/go
export FABRIC_CFG_PATH=${PWD}/../config
chaincode_name=basic
version=1
channel_name=channel-org
org_msp="Org1MSP"
peer_address=localhost:7051
orderer_address=localhost:7050
tls_cert_path=${PWD}/../crypto-config/peerOrganizations/org1.ownify.com/peers/peer0.org1.ownify.com/tls/ca.crt
msp_path=${PWD}/../crypto-config/peerOrganizations/org1.ownify.com/users/Admin@org1.ownify.com/msp
orderer_tls_cert=${PWD}/../crypto-config/ordererOrganizations/ownify.com/orderers/orderer.ownify.com/msp/tlscacerts/tlsca.ownify.com-cert.pem

# Vendoring Go dependencies
vendorGoDependencies() {
    echo Vendoring Go dependencies...
    pushd $chaincode_path
    GO111MODULE=on go mod vendor
    popd
    echo Finished vendoring Go dependencies
}

# Package Chaincode
packageChaincode() {
    echo "Packaging chaincode..."
    peer lifecycle chaincode package ${chaincode_name}.tar.gz \
        --path ${chaincode_path} \
        --lang golang \
        --label ${chaincode_name}_${version}
    echo "Chaincode is packaged."
}

# Install Chaincode
installChaincode() {
    echo "Installing chaincode..."
    peer lifecycle chaincode install ${chaincode_name}.tar.gz
    echo "Chaincode installed on peer0.org1."
}

# Set Environment Variables for Peer
setPeerEnv() {
    export CORE_PEER_TLS_ENABLED=true
    export CORE_PEER_LOCALMSPID="Org1MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=${tls_cert_path}
    export CORE_PEER_MSPCONFIGPATH=${msp_path}
    export CORE_PEER_ADDRESS=${peer_address}
}

# Query Installed Chaincode
queryInstalled() {
    echo "Querying installed chaincode..."
    peer lifecycle chaincode queryinstalled >&log.txt
    PACKAGE_ID=$(sed -n "/${chaincode_name}_${version}/{s/^Package ID: //; s/, Label:.*$//; p;}" log.txt)
    echo "Package ID is ${PACKAGE_ID}"
}

# # Approve for Org1
approveForMyOrg1() {
    echo "Approving chaincode definition for org1..."
    peer lifecycle chaincode approveformyorg -o ${orderer_address} \
        --tls --cafile ${orderer_tls_cert} \
        --channelID ${channel_name} --name ${chaincode_name} \
        --version ${version} --sequence ${version} \
        --package-id ${PACKAGE_ID} --init-required
    echo "Chaincode approved by org1."
}

# # Check Commit Readiness
checkCommitReadyness() {
    echo "Checking commit readiness..."
    peer lifecycle chaincode checkcommitreadiness \
        --channelID ${channel_name} --name ${chaincode_name} \
        --version ${version} --sequence  ${version} --output json --init-required
    echo "Commit readiness checked."
}

# Commit Chaincode Definition
commitChaincodeDefinition() {
    echo "Committing chaincode definition..."
    peer lifecycle chaincode commit -o ${orderer_address} \
        --tls --cafile ${orderer_tls_cert} \
        --channelID ${channel_name} --name ${chaincode_name} \
        --peerAddresses ${peer_address} --tlsRootCertFiles ${tls_cert_path} \
        --version ${version} --sequence ${version} --init-required
    echo "Chaincode definition committed."
}

# Query Committed Chaincode
queryCommitted() {
    echo "Querying committed chaincode..."
    peer lifecycle chaincode querycommitted --channelID ${channel_name} --name ${chaincode_name}
    echo "Chaincode committed."
}

# Chaincode Invoke Init
chaincodeInvokeInit() {
    echo "Invoking chaincode init..."
    # docker network connect test ${peer0}

    peer chaincode invoke -o ${orderer_address} \
        --tls --cafile ${orderer_tls_cert} \
        --channelID ${channel_name} --name ${chaincode_name} \
        --peerAddresses ${peer_address} --tlsRootCertFiles ${tls_cert_path} \
        --isInit -c '{"Args":[]}'
    
    echo "Chaincode initialization invoked."
}


# Execute the functions
vendorGoDependencies
packageChaincode
setPeerEnv 

# Step 2: Chaincode Installation and Approval
installChaincode
queryInstalled
sleep 5        

approveForMyOrg1  
checkCommitReadyness          

# Step 3: Chaincode Commitment
commitChaincodeDefinition
queryCommitted              
sleep 5                         

# Step 4: Chaincode Initialization and Queries
chaincodeInvokeInit