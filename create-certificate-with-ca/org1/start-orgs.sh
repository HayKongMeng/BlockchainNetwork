#!/bin/bash

enroll_admin() {
    echo
    echo "Enroll the CA admin"
    echo "==================="
    echo

    mkdir -p ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/
    export FABRIC_CA_CLIENT_HOME=${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/

    fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 \
                            --caname ca.org1.ownify.com \
                            --tls.certfiles ${PWD}/../fabric-ca/org1/tls-cert.pem
}

enable_node_ous() {
    echo 'NodeOUs:
      Enable: true
      ClientOUIdentifier:
        Certificate: cacerts/localhost-7054-ca-org1-ownify-com.pem
        OrganizationalUnitIdentifier: client
      PeerOUIdentifier:
        Certificate: cacerts/localhost-7054-ca-org1-ownify-com.pem
        OrganizationalUnitIdentifier: peer
      AdminOUIdentifier:
        Certificate: cacerts/localhost-7054-ca-org1-ownify-com.pem
        OrganizationalUnitIdentifier: admin
      OrdererOUIdentifier:
        Certificate: cacerts/localhost-7054-ca-org1-ownify-com.pem
        OrganizationalUnitIdentifier: orderer' >${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/msp/config.yaml
}

register_peers() {
    export FABRIC_CA_CLIENT_HOME=${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/

    for peer in peer0 peer1; do
        echo
        echo "Register $peer"
        echo "=============="
        fabric-ca-client register --caname ca.org1.ownify.com \
            --id.name $peer --id.secret ${peer}pw --id.type peer \
            --tls.certfiles ${PWD}/../fabric-ca/org1/tls-cert.pem
    done
}

register_user() {
    export FABRIC_CA_CLIENT_HOME=${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/

    echo
    echo "Register user"
    echo "============="
    fabric-ca-client register --caname ca.org1.ownify.com \
        --id.name user1 --id.secret user1pw --id.type client \
        --tls.certfiles ${PWD}/../fabric-ca/org1/tls-cert.pem
}

register_org_admin() {
    export FABRIC_CA_CLIENT_HOME=${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/

    echo
    echo "Register the org admin"
    echo "======================"
    fabric-ca-client register --caname ca.org1.ownify.com \
        --id.name org1admin --id.secret org1adminpw --id.type admin \
        --tls.certfiles ${PWD}/../fabric-ca/org1/tls-cert.pem
}

generate_peers_msp() {
    for peer in peer0 peer1; do
        echo
        echo "Generate the ${peer} msp"
        echo "======================"
        
        mkdir -p ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/peers/${peer}.org1.ownify.com

        fabric-ca-client enroll -u https://$peer:${peer}pw@localhost:7054 \
            --caname ca.org1.ownify.com \
            -M ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/peers/${peer}.org1.ownify.com/msp \
            --csr.hosts ${peer}.org1.ownify.com \
            --tls.certfiles ${PWD}/../fabric-ca/org1/tls-cert.pem

        # Copy nodous from msp of org to peer msp
        cp ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/msp/config.yaml ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/peers/${peer}.org1.ownify.com/msp/config.yaml
    done
}

generate_peers_tls_certificates() {
    for peer in peer0 peer1; do
        echo
        echo "Generate the ${peer}-tls certificates"
        echo "==================================="
        
        fabric-ca-client enroll -u https://$peer:${peer}pw@localhost:7054 \
            --caname ca.org1.ownify.com \
            -M ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/peers/${peer}.org1.ownify.com/tls \
            --enrollment.profile tls \
            --csr.hosts ${peer}.org1.ownify.com \
            --csr.hosts localhost \
            --tls.certfiles ${PWD}/../fabric-ca/org1/tls-cert.pem

        mkdir ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/peers/${peer}.org1.ownify.com/msp/tlscacerts
        cp ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/peers/${peer}.org1.ownify.com/tls/tlscacerts/* ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/peers/${peer}.org1.ownify.com/msp/tlscacerts/tlsca.org1.ownify.com-cert.pem
    done
}

copy_and_rename_tls_files() {
    echo
    echo "Rename file for tls communication - peer0"

    # Rename file to ca.crt
    cp ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/peers/peer0.org1.ownify.com/tls/tlscacerts/* ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/peers/peer0.org1.ownify.com/tls/ca.crt
    # Rename file to server.crt
    cp ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/peers/peer0.org1.ownify.com/tls/signcerts/* ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/peers/peer0.org1.ownify.com/tls/server.crt
    # Rename file to server.key
    cp ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/peers/peer0.org1.ownify.com/tls/keystore/* ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/peers/peer0.org1.ownify.com/tls/server.key

    echo
    echo "Rename file for tls communication - peer1"

    cp ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/peers/peer1.org1.ownify.com/tls/tlscacerts/* ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/peers/peer1.org1.ownify.com/tls/ca.crt
    cp ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/peers/peer1.org1.ownify.com/tls/signcerts/* ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/peers/peer1.org1.ownify.com/tls/server.crt
    cp ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/peers/peer1.org1.ownify.com/tls/keystore/* ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/peers/peer1.org1.ownify.com/tls/server.key

}

create_tls_ca_certificate_for_org_msp() {
    echo
    echo "Copy tls ca certificate from tlscacerts directory of peer level to msp of organization level"
    echo

    mkdir ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/msp/tlscacerts
    cp ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/peers/peer0.org1.ownify.com/tls/tlscacerts/* ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/msp/tlscacerts/ca.crt
}

create_tls_ca_certificate_for_org_tlsca() {
    echo
    echo "Copy tls ca certificate from tlscacerts directory of peer level to tlsca of organization level"
    echo

    mkdir ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/tlsca
    cp ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/peers/peer0.org1.ownify.com/tls/tlscacerts/* ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/tlsca/tlsca.org1.ownify.com-cert.pem
}

create_ca_certificate_for_org_ca() {
    echo
    echo "Copy ca certificate from cacerts directory of peer level to ca of organization level"
    echo

    mkdir ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/ca
    cp ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/peers/peer0.org1.ownify.com/msp/cacerts/* ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/ca/ca.org1.ownify.com-cert.pem
    cp ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/msp/keystore/* ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/ca/priv_sk
}

generate_user_msp() {
    echo
    echo "Generate the user msp"
    echo "====================="
    
    mkdir -p ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/users/User1@org1.ownify.com

    fabric-ca-client enroll -u https://user1:user1pw@localhost:7054 \
        --caname ca.org1.ownify.com \
        -M ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/users/User1@org1.ownify.com/msp \
        --tls.certfiles ${PWD}/../fabric-ca/org1/tls-cert.pem

    mv ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/users/User1@org1.ownify.com/msp/keystore/*_sk ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/users/User1@org1.ownify.com/msp/keystore/priv_sk
}

generate_org_admin_msp() {
    echo
    echo "Generate the org admin m sp"
    echo "=========================="
    
    mkdir -p ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/users/Admin@org1.ownify.com

    fabric-ca-client enroll -u https://org1admin:org1adminpw@localhost:7054 \
        --caname ca.org1.ownify.com \
        -M ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/users/Admin@org1.ownify.com/msp \
        --tls.certfiles ${PWD}/../fabric-ca/org1/tls-cert.pem

    # Copy nodous from msp of org to msp of admin
    cp ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/msp/config.yaml ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/users/Admin@org1.ownify.com/msp/config.yaml
    mv ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/users/Admin@org1.ownify.com/msp/keystore/*_sk ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/users/Admin@org1.ownify.com/msp/keystore/priv_sk
}

generate_org_admin_tls() {
    echo
    echo "Generate the org admin tls"
    echo "=========================="
    
    fabric-ca-client enroll -u https://org1admin:org1adminpw@localhost:7054 \
        --caname ca.org1.ownify.com \
        -M ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/users/Admin@org1.ownify.com/tls \
        --enrollment.profile tls \
        --csr.hosts localhost \
        --tls.certfiles ${PWD}/../fabric-ca/org1/tls-cert.pem

    cp ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/users/Admin@org1.ownify.com/tls/tlscacerts/tls-localhost-7054-ca-org1-ownify-com.pem ${PWD}/../../channel/crypto-config/peerOrganizations/org1.ownify.com/users/Admin@org1.ownify.com/tls/ca.crt
}

# Call functions in org
sleep 6s
enroll_admin
sleep 1s
enable_node_ous
sleep 1s
register_peers
sleep 1s
register_user
sleep 1s
register_org_admin
sleep 1s
generate_peers_msp
sleep 1s
generate_peers_tls_certificates
sleep 1s
copy_and_rename_tls_files
sleep 1s
create_tls_ca_certificate_for_org_msp
sleep 1s
create_tls_ca_certificate_for_org_tlsca
sleep 1s
create_ca_certificate_for_org_ca
sleep 1s
generate_user_msp
sleep 1s
generate_org_admin_msp
sleep 1s
generate_org_admin_tls
sleep 1s