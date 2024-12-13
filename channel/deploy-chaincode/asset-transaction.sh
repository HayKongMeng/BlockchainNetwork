# Variables
peer0=peer0.org1.ownify.com
chaincode_path=../src/go
export FABRIC_CFG_PATH=${PWD}/../config
chaincode_name=basic
channel_name=channel-org
org_msp="Org1MSP"
peer_address=localhost:7051
orderer_address=localhost:7050
tls_cert_path=${PWD}/../crypto-config/peerOrganizations/org1.ownify.com/peers/peer0.org1.ownify.com/tls/ca.crt
msp_path=${PWD}/../crypto-config/peerOrganizations/org1.ownify.com/users/Admin@org1.ownify.com/msp
orderer_tls_cert=${PWD}/../crypto-config/ordererOrganizations/ownify.com/orderers/orderer.ownify.com/msp/tlscacerts/tlsca.ownify.com-cert.pem


# Set Environment Variables for Peer
setPeerEnv() {
    export CORE_PEER_TLS_ENABLED=true
    export CORE_PEER_LOCALMSPID="Org1MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=${tls_cert_path}
    export CORE_PEER_MSPCONFIGPATH=${msp_path}
    export CORE_PEER_ADDRESS=${peer_address}
}

# Chaincode Query
chaincodeQuery() {
    echo "Querying all assets on the chaincode..."
    peer chaincode query --channelID ${channel_name} -n ${chaincode_name} \
        -c '{"Args":["QueryAllAssets"]}' | jq
    echo "Chaincode query complete."
}

createAsset() {
    echo "Creating a new asset..."
    peer chaincode invoke -o ${orderer_address} \
    --tls --cafile ${orderer_tls_cert} \
    --channelID ${channel_name} --name ${chaincode_name} \
    --peerAddresses ${peer_address} --tlsRootCertFiles ${tls_cert_path} \
    -c '{"function":"CreateAsset","Args":["Asset1","NewAssetName1","NewUnit","Low","NewAttachment","NewAssignTo","NewUsername","NewDepName","15"]}'
    echo "Asset created successfully."
}


queryAsset() {
    local asset_id=$1 
    echo "Querying asset with ID: ${asset_id}..."
    peer chaincode query --channelID ${channel_name} -n ${chaincode_name} \
        -c "{\"Args\":[\"QueryAsset\", \"${asset_id}\"]}" | jq
    echo "Asset query complete."
}

# Update Asset
updateAsset() {
    local asset_id=$1
    local asset_name=$2
    local unit=$3
    local condition=$4
    local attachment=$5
    local assign_to=$6
    local username=$7
    local dep_name=$8
    local qty=$9

    echo "Updating asset with ID: ${asset_id}..."
    peer chaincode invoke -o ${orderer_address} \
        --tls --cafile ${orderer_tls_cert} \
        --channelID ${channel_name} --name ${chaincode_name} \
        --peerAddresses ${peer_address} --tlsRootCertFiles ${tls_cert_path} \
        -c "{\"function\":\"UpdateAsset\",\"Args\":[\"${asset_id}\",\"${asset_name}\",\"${unit}\",\"${condition}\",\"${attachment}\",\"${assign_to}\",\"${username}\",\"${dep_name}\",\"${qty}\"]}"
    echo "Asset updated successfully."
}


# deleteAsset marks an asset as deleted by invoking DeleteAsset in the chaincode
deleteAsset() {
    local asset_id=$1 
    echo "Marking asset with ID: ${asset_id} as deleted..."
    peer chaincode invoke -o ${orderer_address} \
        --tls --cafile ${orderer_tls_cert} \
        --channelID ${channel_name} --name ${chaincode_name} \
        --peerAddresses ${peer_address} --tlsRootCertFiles ${tls_cert_path} \
        -c "{\"function\":\"DeleteAsset\",\"Args\":[\"${asset_id}\"]}"
    echo "Asset deletion marked successfully."
}

# Query GetAssetHistory for an asset
getAssetHistory() {
    local asset_id=$1
    echo "Retrieving history for asset with ID: ${asset_id}..."
    
    # Use the peer chaincode query command to invoke GetAssetHistory
    peer chaincode query --channelID ${channel_name} -n ${chaincode_name} \
        -c "{\"Args\":[\"GetAssetHistory\", \"${asset_id}\"]}" | jq
    
    echo "Asset history retrieval complete."
}

# Function to transfer an asset to a new owner
transferAsset() {
    local asset_id=$1
    local new_owner=$2
    
    echo "Transferring asset with ID: ${asset_id} to new owner: ${new_owner}..."
    
    peer chaincode invoke -o ${orderer_address} \
        --tls --cafile ${orderer_tls_cert} \
        --channelID ${channel_name} \
        --name ${chaincode_name} \
        --peerAddresses ${peer_address} --tlsRootCertFiles ${tls_cert_path} \
        -c "{\"Args\":[\"TransferAsset\", \"${asset_id}\", \"${new_owner}\"]}" \
        --waitForEvent
    
    echo "Asset transfer complete."
}

getAllAssetHistory() {
    peer chaincode invoke -o localhost:7050 \
    --tls --cafile ${orderer_tls_cert} \
    --channelID ${channel_name} \
    --name ${chaincode_name} \
    --peerAddresses ${peer_address} --tlsRootCertFiles ${tls_cert_path} \
    -c '{"Args":["GetAllAssetHistory"]}'
}

countAsset() {
    echo "Querying all report issues on the chaincode..."
    peer chaincode query --channelID ${channel_name} -n ${chaincode_name} \
        -c '{"Args":["CountAssets"]}' | jq
    echo "Chaincode query complete."
}


setPeerEnv 
sleep 5  
# chaincodeQuery 

# Step 5: Asset Transactions
queryAsset "Asset1"
# createAsset

# updateAsset "Asset2" "Updated Asset Name2" "Units" "Used" "new_attachment.jpg" "User C" "username" "Department B" 150

# deleteAsset "Asset2"
# getAssetHistory "Asset2"
# sleep 3s
# transferAsset "Asset1" "user b"



# deleteAsset "Asset2"
# getAssetHistory "Asset3"
# sleep 3s
# transferAsset "Asset1" "newOwnerUsernameA"

# getAllAssetHistory
# countAsset