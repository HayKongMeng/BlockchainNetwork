export FABRIC_CFG_PATH=${PWD}/configtx

# Generate System Genesis block
configtxgen -profile OrdererGenesis \
            -channelID sys-channel \
            -outputBlock channel-artifacts/genesis.block