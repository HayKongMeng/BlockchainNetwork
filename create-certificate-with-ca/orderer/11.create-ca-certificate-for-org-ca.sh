echo
echo "Copy ca certificate from cacerts directory of orderer level to ca of organization level"
echo

mkdir ${PWD}/../../channel/crypto-config/ordererOrganizations/ownify.com/ca

cp ${PWD}/../../channel/crypto-config/ordererOrganizations/ownify.com/orderers/orderer.ownify.com/msp/cacerts/* ${PWD}/../../channel/crypto-config/ordererOrganizations/ownify.com/ca/ca.ownify.com-cert.pem
cp ${PWD}/../../channel/crypto-config/ordererOrganizations/ownify.com/msp/keystore/* ${PWD}/../../channel/crypto-config/ordererOrganizations/ownify.com/ca/priv_sk