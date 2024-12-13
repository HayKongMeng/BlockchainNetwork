# Variables
peer0="peer0.org1.ownify.com"
chaincode_path="../src/go"
export FABRIC_CFG_PATH="${PWD}/../config"
chaincode_name="basic"
channel_name="channel-org"
org_msp="Org1MSP"
peer_address="localhost:7051"
orderer_address="localhost:7050"
tls_cert_path="${PWD}/../crypto-config/peerOrganizations/org1.ownify.com/peers/peer0.org1.ownify.com/tls/ca.crt"
msp_path="${PWD}/../crypto-config/peerOrganizations/org1.ownify.com/users/Admin@org1.ownify.com/msp"
orderer_tls_cert="${PWD}/../crypto-config/ordererOrganizations/ownify.com/orderers/orderer.ownify.com/msp/tlscacerts/tlsca.ownify.com-cert.pem"


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
    echo "Querying all report issues on the chaincode..."
    peer chaincode query --channelID ${channel_name} -n ${chaincode_name} \
        -c '{"Args":["QueryAllReportIssues"]}' | jq
    echo "Chaincode query complete."
}

createReportIssue() {
    local report_id=$1
    local asset_id=$2       
    local asset_name=$3
    local problem=$4
    local attachment=$5
    local user_id=$6
    local username=$7
    local fullname=$8

    echo "Creating a new report issue with ID: ${report_id}..."
    peer chaincode invoke -o ${orderer_address} \
        --tls --cafile ${orderer_tls_cert} \
        --channelID ${channel_name} --name ${chaincode_name} \
        --peerAddresses ${peer_address} --tlsRootCertFiles ${tls_cert_path} \
        -c "{\"function\":\"CreateReportIssue\",\"Args\":[\"${report_id}\",\"${asset_id}\",\"${asset_name}\",\"${problem}\",\"${attachment}\",\"${user_id}\",\"${username}\",\"${fullname}\"]}"
    echo "Report issue created successfully."
}

# Function to query a ReportIssue by ID
queryReportIssue() {
    local report_id=$1
    echo "Querying report issue with ID: ${report_id}..."
    peer chaincode query --channelID ${channel_name} -n ${chaincode_name} \
        -c "{\"Args\":[\"QueryReportIssue\", \"${report_id}\"]}" | jq
    echo "Query completed."
}

# Update Asset
updateReportIssue() {
    local report_id=$1
    local asset_name=$2
    local problem=$3
    local attachment=$4
    local user_id=$5
    local username=$6

    echo "Updating report issue with ID: ${asset_id}..."
    peer chaincode invoke -o ${orderer_address} \
        --tls --cafile ${orderer_tls_cert} \
        --channelID ${channel_name} --name ${chaincode_name} \
        --peerAddresses ${peer_address} --tlsRootCertFiles ${tls_cert_path} \
        -c "{\"function\":\"UpdateReportIssue\",\"Args\":[\"${report_id}\",\"${asset_id}\",\"${asset_name}\",\"${problem}\",\"${attachment}\",\"${user_id}\",\"${username}\"]}"
}

# Function to delete a ReportIssue by ID
deleteReportIssue() {
    local report_id=$1
    echo "Deleting report issue with ID: ${report_id}..."
    peer chaincode invoke -o ${orderer_address} \
        --tls --cafile ${orderer_tls_cert} \
        --channelID ${channel_name} --name ${chaincode_name} \
        --peerAddresses ${peer_address} --tlsRootCertFiles ${tls_cert_path} \
        -c "{\"function\":\"DeleteReportIssue\",\"Args\":[\"${report_id}\"]}"
    echo "Report issue marked as deleted."
}

# Function to get the history of a ReportIssue by ID
getReportIssueHistory() {
    local report_id=$1
    echo "Retrieving history for report issue with ID: ${report_id}..."
    peer chaincode query --channelID ${channel_name} -n ${chaincode_name} \
        -c "{\"Args\":[\"GetReportIssueHistory\", \"${report_id}\"]}" | jq
    echo "Report issue history retrieval complete."
}

# Function to get all report issue history
getAllReportIssueHistory() {
    response=$(peer chaincode invoke -o localhost:7050 \
    --tls --cafile ${orderer_tls_cert} \
    --channelID ${channel_name} \
    --name ${chaincode_name} \
    --peerAddresses ${peer_address} --tlsRootCertFiles ${tls_cert_path} \
    -c '{"Args":["GetAllReportIssueHistory"]}' 2>&1)

    # Check if the invocation was successful
    if echo "$response" | grep -q "chaincodeInvokeOrQuery -> Chaincode invoke successful"; then
        # Extract the payload from the response
        payload=$(echo "$response" | grep -oP 'payload:"\K[^"]+')

        echo "$payload" | jq .
    else
        echo "Error invoking chaincode: $response"
    fi
}

countReporIssue() {
    echo "Querying all report issues on the chaincode..."
    peer chaincode query --channelID ${channel_name} -n ${chaincode_name} \
        -c '{"Args":["CountReportIssue"]}' | jq
    echo "Chaincode query complete."
}


setPeerEnv
chaincodeQuery
# createReportIssue "Report1" "Asset1" "NewAssetName1" "Issue with assetm id1" "image.jpg" "User1" "user1_username" "phea dalen"
queryReportIssue "Report1"
# updateReportIssue "Report1" "Asset1" "NewAssetName1"  "Issue with asset1" "image.jpg" "User1" "user1_username"
# deleteReportIssue "Report2"
# getReportIssueHistory "Report2"
# getAllReportIssueHistory
# countReporIssue