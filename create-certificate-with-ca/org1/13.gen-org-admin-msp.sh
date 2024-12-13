echo
echo "Generate the org admin msp"
echo "=========================="
echo

mkdir -p ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/users/Admin@org1.ownify.com

fabric-ca-client enroll -u https://org1admin:org1adminpw@localhost:7054 \
    --caname ca.org1.ownify.com \
    -M ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/users/Admin@org1.ownify.com/msp \
    --tls.certfiles ${PWD}/../fabric-ca/org1/tls-cert.pem

# Copy nodous from msp of org to msp of admin
cp ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/msp/config.yaml ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/users/Admin@org1.ownify.com/msp/config.yaml