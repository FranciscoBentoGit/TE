#!/bin/sh
sudo ip -all netns delete
#4.2
sudo ip netns add near
sudo ip netns add far

sudo ip link add one type veth peer name two
sudo ip link set two netns near

sudo ip netns exec near ip link add three type veth peer name four
sudo ip netns exec near ip link set four netns far

sudo ip addr add 10.0.11.1/24 dev one
sudo ip link set dev one up

sudo ip netns exec near ip addr add 10.0.11.2/24 dev two
sudo ip netns exec near ip link set dev two up

sudo ip netns exec near ip addr add 10.0.12.1/24 dev three
sudo ip netns exec near ip link set dev three up

sudo ip netns exec far ip addr add 10.0.12.2/24 dev four
sudo ip netns exec far ip link set dev four up

sudo ip netns exec far ip addr add 10.0.13.1/24 dev lo
sudo ip netns exec far ip link set dev lo up
sudo ip netns exec near ip link set lo up


sudo ip netns exec near sysctl -w net.ipv4.ip_forward=1
sudo ip netns exec far sysctl -w net.ipv4.ip_forward=1

sudo ip route add 10.0.12.0/24 via 10.0.11.2 dev one
sudo ip route add 10.0.13.0/24 via 10.0.11.2 dev one

sudo ip netns exec near ip route add 10.0.13.0/24 via 10.0.12.2 dev three

sudo ip netns exec far ip route add 10.0.11.0/24 via 10.0.12.1 dev four

