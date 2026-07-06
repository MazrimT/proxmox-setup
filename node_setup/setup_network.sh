#!/bin/bash

HOSTNMAME=$(hostname)
IP_ADDR=$(hostname -I | awk '{print $1}')

cat > /etc/hosts <<EOF
127.0.0.1   localhost
$IP_ADDR ${HOSTNAME}.local $HOSTNAME
 
::1         localhost ip6-localhost ip6-loopback
fe00::0     ip6-localnet
ff00::0     ip6-mcastprefix
ff02::1     ip6-allnodes
ff02::2     ip6-allrouters
EOF

cat > /etc/network/interfaces <<EOF
auto eth0
iface eth0 inet static
      address ${IP_ADDR}/24
      gateway 192.168.1.1
EOF

echo "########## hosts ##########"
cat /etc/hosts
echo "########## network/interfaces ##########"
cat /etc/network/interfaces

echo "######### disabling network manager ########"
systemctl disable NetworkManager
systemctl stop NetworkManager
rm /etc/network/interfaces.new -f   # ok if not exists

echo "########## network setup done #########"
ip link show