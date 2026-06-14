# Prebaked
proxmox requires root user, set the Piroot password from 1pass
```bash
sudo passwd root
```

install ifupdown2
```bash
sudo apt install ifupdown2 -y
```

get keys
```bash
sudo curl -L https://mirrors.lierfang.com/pxcloud/lierfang.gpg -o /etc/apt/trusted.gpg.d/lierfang.gpg
```

make file `/etc/apt/sources.list.d/pxvirt-sources.list`
```bash
deb [arch=arm64] https://mirrors.lierfang.com/pxcloud/pxvirt trixie main
```

make file `/etc/apt/sources.list.d/pxvirt-ceph.list`
```bash
deb [arch=arm64] https://download.lierfang.com/pxcloud/pxvirt trixie ceph-squid
```

# Node setup

get ip: `hostname -I`
make sure static ip is set for the pi in router.


in `/etc/hosts` remove everything and put:
```bash
127.0.0.1   localhost
# Add hostname information below
192.168.1.XX pveXX.local pveXX 

::1         localhost ip6-localhost ip6-loopback
fe00::0     ip6-localnet
ff00::0     ip6-mcastprefix
ff02::1     ip6-allnodes
ff02::2     ip6-allrouters
``` 

in `/etc/network/interfaces` remove everything and put:
```bash
auto eth0
iface eth0 inet static
      address 192.168.1.XX/24
      gateway 192.168.1.1
```

```bash
systemctl disable NetworkManager
systemctl stop NetworkManager
rm /etc/network/interfaces.net   # ok if not exists
```
test before rebooting with: `ip link show`

change hostname with
```bash
sudo raspi-config
```
and reboot



install proxmox
```bash
sudo DEBIAN_FRONTEND=noninteractive apt install -y proxmox-ve pve-manager qemu-server pve-cluster
```

make sure proxmox works, then install ceph:
```bash
sudo apt install ceph -y
```


