echo
echo "Generate the peer0 msp"
echo "======================"
echo

mkdir -p ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/peers/peer0.org1.ownify.com

fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 \
    --caname ca.org1.ownify.com \
    -M ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/peers/peer0.org1.ownify.com/msp \
    --csr.hosts peer0.org1.ownify.com \
    --tls.certfiles ${PWD}/../fabric-ca/org1/tls-cert.pem

# Copy nodous from msp of org to peer0 msp
cp ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/msp/config.yaml ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/peers/peer0.org1.ownify.com/msp/config.yaml


#----------------------------
echo
echo "Generate the peer1 msp"
echo "======================"
echo

mkdir -p ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/peers/peer1.org1.ownify.com

fabric-ca-client enroll -u https://peer1:peer1pw@localhost:7054 \
    --caname ca.org1.ownify.com \
    -M ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/peers/peer1.org1.ownify.com/msp \
    --csr.hosts peer1.org1.ownify.com \
    --tls.certfiles ${PWD}/../fabric-ca/org1/tls-cert.pem

# Copy nodous from msp of org to peer0 msp
cp ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/msp/config.yaml ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/peers/peer1.org1.ownify.com/msp/config.yaml



