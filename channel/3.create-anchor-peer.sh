export FABRIC_CFG_PATH=${PWD}/configtx

configtxgen -profile BasicChannel \
            -outputAnchorPeersUpdate ./channel-artifacts/Org1MSPanchors.tx \
            -channelID channel-org \
            -asOrg Org1MSP
