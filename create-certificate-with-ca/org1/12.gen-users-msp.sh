echo
echo "Generate the user msp"
echo "====================="
echo

mkdir -p ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/users/User1@org1.ownify.com

fabric-ca-client enroll -u https://user1:user1pw@localhost:7054 \
    --caname ca.org1.ownify.com \
    -M ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/users/User1@org1.ownify.com/msp \
    --tls.certfiles ${PWD}/../fabric-ca/org1/tls-cert.pem
