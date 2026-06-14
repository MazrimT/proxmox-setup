# setup root user
proxmox requires root user, set the Piroot password from 1pass
`sudo passwd root`

# setup network

make sure static ip is set for the pi in router.

get ip: `hostname -I`

in `/etc/hosts` make sure this line exists:
`192.168.1.XXX pm0X.local pm0X`

# install ifupdown2
```bash
sudo apt update
sudo apt upgrade -y
sudo apt install ifupdown2 -y`
systemctl disable NetworkManager
systemctl stop NetworkManager
rm /etc/network/interfaces.net   # ok if not exists
``` 


# install proxmox


```bash
# get keys
curl -L https://mirrors.lierfang.com/pxcloud/lierfang.gpg -o /etc/apt/trusted.gpg.d/lierfang.gpg
sudo apt update
# change trixie if new version if debian
sudo echo "deb [arch=amd64] https://mirrors.lierfang.com/pxcloud/pxvirt trixie main">/etc/apt/sources.list.d/pxvirt-sources.list
sudo DEBIAN_FRONTEND=noninteractive apt install -y proxmox-ve pve-manager qemu-server pve-cluster
# yes it takes forever
```

# install ceph
has to be done manually

add to `/etc/apt/sources.list.d/pxvirt-ceph.list`:
```bash
deb [arch=amd64] https://download.lierfang.com/pxcloud/pxvirt trixie ceph-squid
```
