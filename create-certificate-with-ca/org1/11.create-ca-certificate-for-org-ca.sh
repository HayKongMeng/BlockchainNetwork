echo
echo "Copy ca certificate from cacerts directory of peer level to ca of organization level"
echo

mkdir ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/ca

cp ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/peers/peer0.org1.ownify.com/msp/cacerts/* ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/ca/ca.org1.ownify.com-cert.pem
cp ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/msp/keystore/* ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/ca/priv_sk