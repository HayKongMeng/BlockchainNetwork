echo
echo "Generate the org admin tls"
echo "=========================="
echo

fabric-ca-client enroll -u https://org1admin:org1adminpw@localhost:7054 \
    --caname ca.org1.ownify.com \
    -M ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/users/Admin@org1.ownify.com/tls \
    --enrollment.profile tls \
    --csr.hosts localhost \
    --tls.certfiles ${PWD}/../fabric-ca/org1/tls-cert.pem

    cp ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/users/Admin@org1.ownify.com/tls/tlscacerts/tls-localhost-7054-ca-org1-ownify-com.pem ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/users/Admin@org1.ownify.com/tls/ca.crt