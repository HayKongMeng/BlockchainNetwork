export FABRIC_CA_CLIENT_HOME=${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/

echo
echo "Register the org admin"
echo "======================"
echo

fabric-ca-client register --caname ca.org1.ownify.com \
    --id.name org1admin --id.secret org1adminpw --id.type admin \
    --tls.certfiles ${PWD}/../fabric-ca/org1/tls-cert.pem
