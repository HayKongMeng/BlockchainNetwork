export FABRIC_CFG_PATH=${PWD}/config

export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/crypto-config/peerOrganizations/org1.ownify.com/peers/peer0.org1.ownify.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/crypto-config/peerOrganizations/org1.ownify.com/users/Admin@org1.ownify.com/msp
export CORE_PEER_ADDRESS=localhost:7051

peer channel create -o localhost:7050  \
    --ordererTLSHostnameOverride orderer.ownify.com \
    -c channel-org -f ./channel-artifacts/mychannel.tx \
    --outputBlock ./channel-artifacts/channel1.block \
    --tls --cafile ${PWD}/crypto-config/ordererOrganizations/ownify.com/orderers/orderer.ownify.com/msp/tlscacerts/tlsca.ownify.com-cert.pem