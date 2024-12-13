echo
echo "Copy tls ca certificate from tlscacerts directory of peer level to msp of organization level"
echo

mkdir ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/msp/tlscacerts
cp ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/peers/peer0.org1.ownify.com/tls/tlscacerts/* ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/msp/tlscacerts/ca.crt