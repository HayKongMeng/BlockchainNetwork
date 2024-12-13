export FABRIC_CA_CLIENT_HOME=${PWD}/../../channel/crypto-config/ordererOrganizations/ownify.com

fabric-ca-client register --caname ca-orderer \
    --id.name ordererAdmin --id.secret ordererAdminpw \
    --id.type admin --tls.certfiles ${PWD}/../fabric-ca/ordererOrg/tls-cert.pem
