echo
echo "Generate the orderer-tls certificates"
echo "====================================="
echo

fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 \
    --caname ca-orderer \
    -M ${PWD}/../../channel/crypto-config/ordererOrganizations/ownify.com/orderers/orderer.ownify.com/tls \
    --enrollment.profile tls \
    --csr.hosts orderer.ownify.com \
    --csr.hosts localhost \
    --tls.certfiles ${PWD}/../fabric-ca/ordererOrg/tls-cert.pem



echo
echo "Generate the orderer2-tls certificates"
echo "======================================"
echo
   
fabric-ca-client enroll -u https://orderer2:ordererpw@localhost:9054 \
    --caname ca-orderer \
    -M ${PWD}/../../channel/crypto-config/ordererOrganizations/ownify.com/orderers/orderer2.ownify.com/tls \
    --enrollment.profile tls \
    --csr.hosts orderer2.ownify.com \
    --csr.hosts localhost \
    --tls.certfiles ${PWD}/../fabric-ca/ordererOrg/tls-cert.pem



echo
echo "Generate the orderer3-tls certificates"
echo "======================================"
echo
   
fabric-ca-client enroll -u https://orderer3:ordererpw@localhost:9054 \
    --caname ca-orderer \
    -M ${PWD}/../../channel/crypto-config/ordererOrganizations/ownify.com/orderers/orderer3.ownify.com/tls \
    --enrollment.profile tls \
    --csr.hosts orderer3.ownify.com \
    --csr.hosts localhost \
    --tls.certfiles ${PWD}/../fabric-ca/ordererOrg/tls-cert.pem
