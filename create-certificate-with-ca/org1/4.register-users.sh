export FABRIC_CA_CLIENT_HOME=${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/

  echo
  echo "Register user"
  echo "============="
  echo
  fabric-ca-client register --caname ca.org1.ownify.com \
    --id.name user1 --id.secret user1pw --id.type client \
    --tls.certfiles ${PWD}/../fabric-ca/org1/tls-cert.pem
