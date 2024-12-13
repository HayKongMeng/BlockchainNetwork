echo
echo "Enroll the CA admin"
echo "==================="
echo

mkdir -p ${PWD}/../../channel/crypto-config/ordererOrganizations/ownify.com
export FABRIC_CA_CLIENT_HOME=${PWD}/../../channel/crypto-config/ordererOrganizations/ownify.com

fabric-ca-client enroll -u https://admin:adminpw@localhost:9054 \
                        --caname ca-orderer \
                        --tls.certfiles ${PWD}/../fabric-ca/ordererOrg/tls-cert.pem
 