#!/bin/bash

function one_line_pem {
    echo "`awk 'NF {sub(/\\n/, ""); printf "%s\\\\\\\n",$0;}' $1`"
}

function json_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    local PP1=$(one_line_pem $6)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        -e "s#\${PEERPEM1}#$PP1#" \
        -e "s#\${P0PORT1}#$7#" \
        ./ccp-template.json
}

ORG=1
P0PORT=7051
CAPORT=7054
P0PORT1=8051
PEERPEM=${PWD}/../channel/crypto-config/peerOrganizations/org1.ownify.com/peers/peer0.org1.ownify.com/msp/tlscacerts/tlsca.org1.ownify.com-cert.pem
PEERPEM1=${PWD}/../channel/crypto-config/peerOrganizations/org1.ownify.com/peers/peer1.org1.ownify.com/msp/tlscacerts/tlsca.org1.ownify.com-cert.pem
CAPEM=${PWD}/../channel/crypto-config/peerOrganizations/org1.ownify.com/msp/tlscacerts/ca.crt

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $PEERPEM1 $P0PORT1)" > connection-org1.json

# Copy the entire crypto-config folder, including the folder itself
CRYPTO_CONFIG_SRC="/home/dalen/ownership/ownership-network/channel/crypto-config"
DESTINATION="/home/dalen/ownership/ownership-api/src/main/resources"

if [ -d "$CRYPTO_CONFIG_SRC" ]; then
    echo "crypto-config folder found, copying the entire folder to destination..."
    cp -r "$CRYPTO_CONFIG_SRC" "$DESTINATION"
    echo "crypto-config folder copy completed."
else
    echo "crypto-config folder not found, no copy performed."
fi

# Copy connection-org1.json to destination
if [ -f "connection-org1.json" ]; then
    echo "connection-org1.json generated, copying to destination..."
    cp connection-org1.json "$DESTINATION"
    echo "connection-org1.json copy completed."
else
    echo "connection-org1.json not found, no copy performed."
fi
