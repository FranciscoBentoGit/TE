#!/bin/sh
sudo ip -all netns delete
#4.3
# Create namespaces
sudo ip netns add H1
sudo ip netns add H2
sudo ip netns add H3
sudo ip netns add H4
sudo ip netns add H5
sudo ip netns add H6
sudo ip netns add H7

sudo ip netns add SW1
sudo ip netns add SW2
sudo ip netns add SW3

sudo ip netns add R1
sudo ip netns add R2

# Create VETH pairs and assign them to the respective namespaces
sudo ip link add veth_H1 type veth peer name veth_H1_SW1
sudo ip link add veth_H2 type veth peer name veth_H2_SW1
sudo ip link add veth_H3 type veth peer name veth_H3_SW2
sudo ip link add veth_H4 type veth peer name veth_H4_SW2
sudo ip link add veth_H5 type veth peer name veth_H5_SW3
sudo ip link add veth_H6 type veth peer name veth_H6_SW3
sudo ip link add veth_H7 type veth peer name veth_H7_SW3

sudo ip link add veth_SW1_R1 type veth peer name veth_R1_SW1
sudo ip link add veth_SW2_R2 type veth peer name veth_R2_SW2
sudo ip link add veth_SW3_R1 type veth peer name veth_R1_SW3
sudo ip link add veth_R1_R2 type veth peer name veth_R2_R1

sudo ip link set veth_H1 netns H1
sudo ip link set veth_H2 netns H2
sudo ip link set veth_H3 netns H3
sudo ip link set veth_H4 netns H4
sudo ip link set veth_H5 netns H5
sudo ip link set veth_H6 netns H6
sudo ip link set veth_H7 netns H7

sudo ip link set veth_H1_SW1 netns SW1
sudo ip link set veth_H2_SW1 netns SW1
sudo ip link set veth_SW1_R1 netns SW1

sudo ip link set veth_H3_SW2 netns SW2
sudo ip link set veth_H4_SW2 netns SW2
sudo ip link set veth_SW2_R2 netns SW2

sudo ip link set veth_H5_SW3 netns SW3
sudo ip link set veth_H6_SW3 netns SW3
sudo ip link set veth_H7_SW3 netns SW3
sudo ip link set veth_SW3_R1 netns SW3


sudo ip link set veth_R1_SW1 netns R1
sudo ip link set veth_R2_SW2 netns R2
sudo ip link set veth_R1_SW3 netns R1
sudo ip link set veth_R1_R2 netns R1
sudo ip link set veth_R2_R1 netns R2



# Create and configure bridges for the switch devices
sudo ip netns exec SW1 ip link add name br_SW1 type bridge
sudo ip netns exec SW1 ip link set br_SW1 up
sudo ip netns exec SW1 ip link set dev veth_H1_SW1 master br_SW1
sudo ip netns exec SW1 ip link set dev veth_H2_SW1 master br_SW1
sudo ip netns exec SW1 ip link set dev veth_SW1_R1 master br_SW1
sudo ip netns exec SW1 ip link set dev veth_H1_SW1 up
sudo ip netns exec SW1 ip link set dev veth_H2_SW1 up
sudo ip netns exec SW1 ip link set dev veth_SW1_R1 up

sudo ip netns exec SW2 ip link add name br_SW2 type bridge
sudo ip netns exec SW2 ip link set br_SW2 up
sudo ip netns exec SW2 ip link set dev veth_H3_SW2 master br_SW2
sudo ip netns exec SW2 ip link set dev veth_H4_SW2 master br_SW2
sudo ip netns exec SW2 ip link set dev veth_SW2_R2 master br_SW2
sudo ip netns exec SW2 ip link set dev veth_H3_SW2 up
sudo ip netns exec SW2 ip link set dev veth_H4_SW2 up
sudo ip netns exec SW2 ip link set dev veth_SW2_R2 up

sudo ip netns exec SW3 ip link add name br_SW3 type bridge
sudo ip netns exec SW3 ip link set br_SW3 up
sudo ip netns exec SW3 ip link set dev veth_H5_SW3 master br_SW3
sudo ip netns exec SW3 ip link set dev veth_H6_SW3 master br_SW3
sudo ip netns exec SW3 ip link set dev veth_H7_SW3 master br_SW3
sudo ip netns exec SW3 ip link set dev veth_SW3_R1 master br_SW3
sudo ip netns exec SW3 ip link set dev veth_H5_SW3 up
sudo ip netns exec SW3 ip link set dev veth_H6_SW3 up
sudo ip netns exec SW3 ip link set dev veth_H7_SW3 up
sudo ip netns exec SW3 ip link set dev veth_SW3_R1 up


# Bring up and Assign IP addresses to Hosts and Routers
sudo ip netns exec H1 ip addr add 10.0.10.1/24 dev veth_H1
sudo ip netns exec H1 ip link set dev veth_H1 up

sudo ip netns exec H2 ip addr add 10.0.10.2/24 dev veth_H2
sudo ip netns exec H2 ip link set dev veth_H2 up

sudo ip netns exec H3 ip addr add 10.0.20.3/24 dev veth_H3
sudo ip netns exec H3 ip link set dev veth_H3 up

sudo ip netns exec H4 ip addr add 10.0.20.4/24 dev veth_H4
sudo ip netns exec H4 ip link set dev veth_H4 up

sudo ip netns exec H5 ip addr add 10.0.30.5/24 dev veth_H5
sudo ip netns exec H5 ip link set dev veth_H5 up

sudo ip netns exec H6 ip addr add 10.0.30.6/24 dev veth_H6
sudo ip netns exec H6 ip link set dev veth_H6 up

sudo ip netns exec H7 ip addr add 10.0.30.7/24 dev veth_H7
sudo ip netns exec H7 ip link set dev veth_H7 up

sudo ip netns exec R1 ip addr add 10.0.10.254/24 dev veth_R1_SW1
sudo ip netns exec R1 ip addr add 10.0.30.254/24 dev veth_R1_SW3
sudo ip netns exec R1 ip addr add 10.0.40.1/24 dev veth_R1_R2
sudo ip netns exec R1 ip link set dev veth_R1_SW1 up
sudo ip netns exec R1 ip link set dev veth_R1_SW3 up
sudo ip netns exec R1 ip link set dev veth_R1_R2 up

sudo ip netns exec R2 ip addr add 10.0.20.254/24 dev veth_R2_SW2
sudo ip netns exec R2 ip addr add 10.0.40.2/24 dev veth_R2_R1
sudo ip netns exec R2 ip link set dev veth_R2_SW2 up
sudo ip netns exec R2 ip link set dev veth_R2_R1 up


#Enable IP forwarding on Routers and Configure Routing tables
sudo ip netns exec R1 sysctl -w net.ipv4.ip_forward=1
sudo ip netns exec R2 sysctl -w net.ipv4.ip_forward=1

sudo ip netns exec H1 ip route add default via 10.0.10.254
sudo ip netns exec H2 ip route add default via 10.0.10.254
sudo ip netns exec H3 ip route add default via 10.0.20.254
sudo ip netns exec H4 ip route add default via 10.0.20.254
sudo ip netns exec H5 ip route add default via 10.0.30.254
sudo ip netns exec H6 ip route add default via 10.0.30.254
sudo ip netns exec H7 ip route add default via 10.0.30.254

sudo ip netns exec R1 ip route add 10.0.20.0/24 via 10.0.40.2

sudo ip netns exec R2 ip route add 10.0.10.0/24 via 10.0.40.1
sudo ip netns exec R2 ip route add 10.0.30.0/24 via 10.0.40.1







