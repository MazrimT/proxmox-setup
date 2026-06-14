# setup root user
proxmox requires root user, set the Piroot password from 1pass
```bash
# prebaked
sudo passwd root
```

# setup network
> [!IMPORTANT]
> IF NOT DONE FIRST INSTALLATION BRICKS!

make sure static ip is set for the pi in router.

get ip: `hostname -I`

in `/etc/hosts` make sure this line exists:
`192.168.1.XXX pm0X.local pm0X`

# install ifupdown2

```bash
# prebaked
sudo apt update
sudo apt upgrade -y
sudo apt install ifupdown2 -y`
```

```bash
systemctl disable NetworkManager
systemctl stop NetworkManager
rm /etc/network/interfaces.net   # ok if not exists
``` 


# install proxmox

```bash
# prebaked
# get keys
curl -L https://mirrors.lierfang.com/pxcloud/lierfang.gpg -o /etc/apt/trusted.gpg.d/lierfang.gpg
sudo apt update
# change trixie if new version if debian
sudo echo "deb [arch=arm64] https://mirrors.lierfang.com/pxcloud/pxvirt trixie main">/etc/apt/sources.list.d/pxvirt-sources.list
```

### actual install command:
```bash
sudo DEBIAN_FRONTEND=noninteractive apt install -y proxmox-ve pve-manager qemu-server pve-cluster
```

# install ceph

```bash
# prebaked

# add to `/etc/apt/sources.list.d/pxvirt-ceph.list`
deb [arch=arm64] https://download.lierfang.com/pxcloud/pxvirt trixie ceph-squid
```

has to be done manually **NOT IN THE WEB UI**
```bash
sudo apt install ceph -y
```


# cloing with rpi-clone
```bash
rpi-clone nvme0n1 -v -U
```
