
echo
echo "Generate the orderer msp"
echo "========================"
echo
   
mkdir -p ${PWD}/../../channel/crypto-config/ordererOrganizations/ownify.com/orderers/orderer.ownify.com
fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 \
    --caname ca-orderer \
    -M ${PWD}/../../channel/crypto-config/ordererOrganizations/ownify.com/orderers/orderer.ownify.com/msp \
    --csr.hosts orderer.ownify.com \
    --csr.hosts localhost \
    --tls.certfiles ${PWD}/../fabric-ca/ordererOrg/tls-cert.pem
   
cp ${PWD}/../../channel/crypto-config/ordererOrganizations/ownify.com/msp/config.yaml ${PWD}/../../channel/crypto-config/ordererOrganizations/ownify.com/orderers/orderer.ownify.com/msp/config.yaml



echo
echo "Generate the orderer2 msp"
echo "========================="
echo
   
mkdir -p ${PWD}/../../channel/crypto-config/ordererOrganizations/ownify.com/orderers/orderer2.ownify.com

fabric-ca-client enroll -u https://orderer2:ordererpw@localhost:9054 \
    --caname ca-orderer \
    -M ${PWD}/../../channel/crypto-config/ordererOrganizations/ownify.com/orderers/orderer2.ownify.com/msp \
    --csr.hosts orderer2.ownify.com \
    --csr.hosts localhost \
    --tls.certfiles ${PWD}/../fabric-ca/ordererOrg/tls-cert.pem
   
cp ${PWD}/../../channel/crypto-config/ordererOrganizations/ownify.com/msp/config.yaml ${PWD}/../../channel/crypto-config/ordererOrganizations/ownify.com/orderers/orderer2.ownify.com/msp/config.yaml



echo
echo "Generate the orderer3 msp"
echo "========================="
echo

mkdir -p ${PWD}/../../channel/crypto-config/ordererOrganizations/ownify.com/orderers/orderer3.ownify.com

fabric-ca-client enroll -u https://orderer3:ordererpw@localhost:9054 \
    --caname ca-orderer \
    -M ${PWD}/../../channel/crypto-config/ordererOrganizations/ownify.com/orderers/orderer3.ownify.com/msp \
    --csr.hosts orderer3.ownify.com \
    --csr.hosts localhost \
    --tls.certfiles ${PWD}/../fabric-ca/ordererOrg/tls-cert.pem
   
cp ${PWD}/../../channel/crypto-config/ordererOrganizations/ownify.com/msp/config.yaml ${PWD}/../../channel/crypto-config/ordererOrganizations/ownify.com/orderers/orderer3.ownify.com/msp/config.yaml
