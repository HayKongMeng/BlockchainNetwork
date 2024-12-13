echo
echo "Copy tls ca certificate from tlscacerts directory of peer level to tlsca of organization level"
echo

mkdir ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/tlsca
cp ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/peers/peer0.org1.ownify.com/tls/tlscacerts/* ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/tlsca/tlsca.org1.ownify.com-cert.pem
