echo
echo "Generate the peer0-tls certificates"
echo "==================================="
echo

fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 \
    --caname ca.org1.ownify.com \
    -M ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/peers/peer0.org1.ownify.com/tls \
    --enrollment.profile tls \
    --csr.hosts peer0.org1.ownify.com \
    --csr.hosts localhost \
    --tls.certfiles ${PWD}/../fabric-ca/org1/tls-cert.pem

mkdir ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/peers/peer0.org1.ownify.com/msp/tlscacerts
cp ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/peers/peer0.org1.ownify.com/tls/tlscacerts/* ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/peers/peer0.org1.ownify.com/msp/tlscacerts/tlsca.org1.ownify.com-cert.pem

#----------------------------
echo
echo "Generate the peer1-tls certificates"
echo "==================================="
echo
  
fabric-ca-client enroll -u https://peer1:peer1pw@localhost:7054 \
    --caname ca.org1.ownify.com \
    -M ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/peers/peer1.org1.ownify.com/tls \
    --enrollment.profile tls \
    --csr.hosts peer1.org1.ownify.com \
    --csr.hosts localhost \
    --tls.certfiles ${PWD}/../fabric-ca/org1/tls-cert.pem

mkdir ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/peers/peer1.org1.ownify.com/msp/tlscacerts
cp ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/peers/peer1.org1.ownify.com/tls/tlscacerts/* ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/peers/peer1.org1.ownify.com/msp/tlscacerts/tlsca.org1.ownify.com-cert.pem
