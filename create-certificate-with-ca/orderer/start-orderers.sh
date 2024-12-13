#!/bin/bash

enroll_admin() {
    echo
    echo "Enroll the CA admin"
    echo "==================="
    echo

    mkdir -p ${PWD}/../../channel/crypto-config/ordererOrganizations/ownify.com
    export FABRIC_CA_CLIENT_HOME=${PWD}/../../channel/crypto-config/ordererOrganizations/ownify.com

    fabric-ca-client enroll -u https://admin:adminpw@localhost:9054 \
                            --caname ca-orderer \
                            --tls.certfiles ${PWD}/../fabric-ca/ordererOrg/tls-cert.pem
}

enable_node_ous() {
    echo 'NodeOUs:
      Enable: true
      ClientOUIdentifier:
        Certificate: cacerts/localhost-9054-ca-orderer.pem
        OrganizationalUnitIdentifier: client
      PeerOUIdentifier:
        Certificate: cacerts/localhost-9054-ca-orderer.pem
        OrganizationalUnitIdentifier: peer
      AdminOUIdentifier:
        Certificate: cacerts/localhost-9054-ca-orderer.pem
        OrganizationalUnitIdentifier: admin
      OrdererOUIdentifier:
        Certificate: cacerts/localhost-9054-ca-orderer.pem
        OrganizationalUnitIdentifier: orderer' >${PWD}/../../channel/crypto-config/ordererOrganizations/ownify.com/msp/config.yaml
}

register_orderers() {
    export FABRIC_CA_CLIENT_HOME=${PWD}/../../channel/crypto-config/ordererOrganizations/ownify.com

    for orderer in orderer orderer2 orderer3; do
        echo
        echo "Register $orderer"
        echo "================"
        
        fabric-ca-client register --caname ca-orderer \
            --id.name $orderer --id.secret ordererpw \
            --id.type orderer --tls.certfiles ${PWD}/../fabric-ca/ordererOrg/tls-cert.pem
    done

    # Register ordererAdmin
    fabric-ca-client register --caname ca-orderer \
        --id.name ordererAdmin --id.secret ordererAdminpw \
        --id.type admin --tls.certfiles ${PWD}/../fabric-ca/ordererOrg/tls-cert.pem
}

generate_orderer_msp() {
    for orderer in orderer orderer2 orderer3; do
        echo
        echo "Generate the ${orderer} msp"
        echo "========================"
        
        mkdir -p ${PWD}/../../channel/crypto-config/ordererOrganizations/ownify.com/orderers/${orderer}.ownify.com
        fabric-ca-client enroll -u https://$orderer:ordererpw@localhost:9054 \
            --caname ca-orderer \
            -M ${PWD}/../../channel/crypto-config/ordererOrganizations/ownify.com/orderers/${orderer}.ownify.com/msp \
            --csr.hosts ${orderer}.ownify.com \
            --csr.hosts localhost \
            --tls.certfiles ${PWD}/../fabric-ca/ordererOrg/tls-cert.pem
        
        cp ${PWD}/../../channel/crypto-config/ordererOrganizations/ownify.com/msp/config.yaml ${PWD}/../../channel/crypto-config/ordererOrganizations/ownify.com/orderers/${orderer}.ownify.com/msp/config.yaml
    done
}

generate_orderer_tls_certificates() {
    for orderer in orderer orderer2 orderer3; do
        echo
        echo "Generate the ${orderer}-tls certificates"
        echo "====================================="
        
        fabric-ca-client enroll -u https://$orderer:ordererpw@localhost:9054 \
            --caname ca-orderer \
            -M ${PWD}/../../channel/crypto-config/ordererOrganizations/ownify.com/orderers/${orderer}.ownify.com/tls \
            --enrollment.profile tls \
            --csr.hosts ${orderer}.ownify.com \
            --csr.hosts localhost \
            --tls.certfiles ${PWD}/../fabric-ca/ordererOrg/tls-cert.pem
    done
}

copy_and_rename_tls_files() {
    cp ${PWD}/../../channel/crypto-config/ordererOrganizations/ownify.com/orderers/orderer.ownify.com/tls/tlscacerts/* ${PWD}/../../channel/crypto-config/ordererOrganizations/ownify.com/orderers/orderer.ownify.com/tls/ca.crt
    cp ${PWD}/../../channel/crypto-config/ordererOrganizations/ownify.com/orderers/orderer.ownify.com/tls/signcerts/* ${PWD}/../../channel/crypto-config/ordererOrganizations/ownify.com/orderers/orderer.ownify.com/tls/server.crt
    cp ${PWD}/../../channel/crypto-config/ordererOrganizations/ownify.com/orderers/orderer.ownify.com/tls/keystore/* ${PWD}/../../channel/crypto-config/ordererOrganizations/ownify.com/orderers/orderer.ownify.com/tls/server.key


    cp ${PWD}/../../channel/crypto-config/ordererOrganizations/ownify.com/orderers/orderer2.ownify.com/tls/tlscacerts/* ${PWD}/../../channel/crypto-config/ordererOrganizations/ownify.com/orderers/orderer2.ownify.com/tls/ca.crt
    cp ${PWD}/../../channel/crypto-config/ordererOrganizations/ownify.com/orderers/orderer2.ownify.com/tls/signcerts/* ${PWD}/../../channel/crypto-config/ordererOrganizations/ownify.com/orderers/orderer2.ownify.com/tls/server.crt
    cp ${PWD}/../../channel/crypto-config/ordererOrganizations/ownify.com/orderers/orderer2.ownify.com/tls/keystore/* ${PWD}/../../channel/crypto-config/ordererOrganizations/ownify.com/orderers/orderer2.ownify.com/tls/server.key


    cp ${PWD}/../../channel/crypto-config/ordererOrganizations/ownify.com/orderers/orderer3.ownify.com/tls/tlscacerts/* ${PWD}/../../channel/crypto-config/ordererOrganizations/ownify.com/orderers/orderer3.ownify.com/tls/ca.crt
    cp ${PWD}/../../channel/crypto-config/ordererOrganizations/ownify.com/orderers/orderer3.ownify.com/tls/signcerts/* ${PWD}/../../channel/crypto-config/ordererOrganizations/ownify.com/orderers/orderer3.ownify.com/tls/server.crt
    cp ${PWD}/../../channel/crypto-config/ordererOrganizations/ownify.com/orderers/orderer3.ownify.com/tls/keystore/* ${PWD}/../../channel/crypto-config/ordererOrganizations/ownify.com/orderers/orderer3.ownify.com/tls/server.key

}

create_tls_ca_certificates_for_orderers() {
    for orderer in orderer orderer2 orderer3; do
        mkdir ${PWD}/../../channel/crypto-config/ordererOrganizations/ownify.com/orderers/${orderer}.ownify.com/msp/tlscacerts
        cp ${PWD}/../../channel/crypto-config/ordererOrganizations/ownify.com/orderers/${orderer}.ownify.com/tls/tlscacerts/* ${PWD}/../../channel/crypto-config/ordererOrganizations/ownify.com/orderers/${orderer}.ownify.com/msp/tlscacerts/tlsca.ownify.com-cert.pem
    done
}

create_tls_ca_certificate_for_org_msp() {
    mkdir ${PWD}/../../channel/crypto-config/ordererOrganizations/ownify.com/msp/tlscacerts
    cp ${PWD}/../../channel/crypto-config/ordererOrganizations/ownify.com/orderers/orderer.ownify.com/tls/tlscacerts/* ${PWD}/../../channel/crypto-config/ordererOrganizations/ownify.com/msp/tlscacerts/tlsca.ownify.com-cert.pem
}

create_tls_ca_certificate_for_org_tlsca() {
    echo
    echo "Copy tls ca certificate from tlscacerts directory of orderer level to tlsca of organization level"
    echo

    mkdir ${PWD}/../../channel/crypto-config/ordererOrganizations/ownify.com/tlsca
    cp ${PWD}/../../channel/crypto-config/ordererOrganizations/ownify.com/orderers/orderer.ownify.com/tls/tlscacerts/* ${PWD}/../../channel/crypto-config/ordererOrganizations/ownify.com/tlsca/tlsca.ownify.com-cert.pem
}

create_ca_certificate_for_org_ca() {
    echo
    echo "Copy ca certificate from cacerts directory of orderer level to ca of organization level"
    echo

    mkdir ${PWD}/../../channel/crypto-config/ordererOrganizations/ownify.com/ca
    cp ${PWD}/../../channel/crypto-config/ordererOrganizations/ownify.com/orderers/orderer.ownify.com/msp/cacerts/* ${PWD}/../../channel/crypto-config/ordererOrganizations/ownify.com/ca/ca.ownify.com-cert.pem
    cp ${PWD}/../../channel/crypto-config/ordererOrganizations/ownify.com/msp/keystore/* ${PWD}/../../channel/crypto-config/ordererOrganizations/ownify.com/ca/priv_sk
}


sleep 6s
enroll_admin
sleep 1s
enable_node_ous
sleep 1s
register_orderers
sleep 1s
generate_orderer_msp
sleep 1s
generate_orderer_tls_certificates
sleep 1s
copy_and_rename_tls_files
sleep 1s
create_tls_ca_certificates_for_orderers
sleep 1s
create_tls_ca_certificate_for_org_msp
sleep 1s
create_tls_ca_certificate_for_org_tlsca
sleep 1s
create_ca_certificate_for_org_ca
sleep 1s