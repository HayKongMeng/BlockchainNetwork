export FABRIC_CA_CLIENT_HOME=${PWD}/../../channel/crypto-config/ordererOrganizations/ownify.com

echo
echo "Register orderer"
echo "================"
echo
   
fabric-ca-client register --caname ca-orderer \
    --id.name orderer --id.secret ordererpw \
    --id.type orderer --tls.certfiles ${PWD}/../fabric-ca/ordererOrg/tls-cert.pem

  
echo
echo "Register orderer2"
echo "================="
echo
   
fabric-ca-client register --caname ca-orderer \
    --id.name orderer2 --id.secret ordererpw \
    --id.type orderer --tls.certfiles ${PWD}/../fabric-ca/ordererOrg/tls-cert.pem


echo
echo "Register orderer3"
echo "================="
echo
   
fabric-ca-client register --caname ca-orderer \
    --id.name orderer3 --id.secret ordererpw \
    --id.type orderer --tls.certfiles ${PWD}/../fabric-ca/ordererOrg/tls-cert.pem
  
   