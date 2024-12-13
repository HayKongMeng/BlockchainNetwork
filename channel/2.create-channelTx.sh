export FABRIC_CFG_PATH=${PWD}/configtx

# Generate channel configuration
configtxgen -profile BasicChannel \
            -channelID channel-org \
            -outputCreateChannelTx channel-artifacts/mychannel.tx