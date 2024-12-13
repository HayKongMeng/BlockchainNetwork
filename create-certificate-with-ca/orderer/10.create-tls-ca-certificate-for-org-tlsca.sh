echo
echo "Copy tls ca certificate from tlscacerts directory of orderer level to tlsca of organization level"
echo

mkdir ${PWD}/../../channel/crypto-config/ordererOrganizations/ownify.com/tlsca
cp ${PWD}/../../channel/crypto-config/ordererOrganizations/ownify.com/orderers/orderer.ownify.com/tls/tlscacerts/* ${PWD}/../../channel/crypto-config/ordererOrganizations/ownify.com/tlsca/tlsca.ownify.com-cert.pem