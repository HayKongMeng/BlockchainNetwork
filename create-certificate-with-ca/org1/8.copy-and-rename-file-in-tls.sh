echo
echo "Rename file for tls communication - peer0"

# Rename file to ca.crt
cp ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/peers/peer0.org1.ownify.com/tls/tlscacerts/* ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/peers/peer0.org1.ownify.com/tls/ca.crt
# Rename file to server.crt
cp ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/peers/peer0.org1.ownify.com/tls/signcerts/* ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/peers/peer0.org1.ownify.com/tls/server.crt
# Rename file to server.key
cp ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/peers/peer0.org1.ownify.com/tls/keystore/* ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/peers/peer0.org1.ownify.com/tls/server.key

echo
echo "Rename file for tls communication - peer1"

cp ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/peers/peer1.org1.ownify.com/tls/tlscacerts/* ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/peers/peer1.org1.ownify.com/tls/ca.crt
cp ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/peers/peer1.org1.ownify.com/tls/signcerts/* ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/peers/peer1.org1.ownify.com/tls/server.crt
cp ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/peers/peer1.org1.ownify.com/tls/keystore/* ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/peers/peer1.org1.ownify.com/tls/server.key
