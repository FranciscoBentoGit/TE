#!/bin/sh
sudo ip -all netns delete
#4.1
sudo ip netns add examplens

sudo ip link add external type veth peer name internal
sudo ip link set internal netns examplens

sudo ip netns exec examplens ip addr add 10.0.0.2/24 dev internal
sudo ip netns exec examplens ip link set dev internal up

sudo ip addr add 10.0.0.1/24 dev external
sudo ip link set dev external up

