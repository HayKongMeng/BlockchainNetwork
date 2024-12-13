./1.create-genesis-block.sh
sleep 2s
./2.create-channelTx.sh
sleep 2s
./3.create-anchor-peer.sh
sleep 2s
./4.up-network.sh
sleep 2s

./5.create-app-channel.sh
sleep 2s
./6.join-peers-to-channel.sh
sleep 1s
./7.update-anchor-peers.sh
sleep 1s