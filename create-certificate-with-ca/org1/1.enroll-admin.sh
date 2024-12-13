echo
echo "Enroll the CA admin"
echo "==================="
echo

mkdir -p ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/
export FABRIC_CA_CLIENT_HOME=${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/

fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 \
                        --caname ca.org1.ownify.com \
                        --tls.certfiles ${PWD}/../fabric-ca/org1/tls-cert.pem