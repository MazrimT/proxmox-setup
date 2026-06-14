# setup root user
proxmox requires root user, set the Piroot password from 1pass
```bash
# prebaked
sudo passwd root
```

# setup network
> [!IMPORTANT]
> IF NOT DONE FIRST INSTALLATION BRICKS!
>
> make sure the IP-address gets reserved in the router!
> make a backup of router settings just in case

make sure static ip is set for the pi in router.

get ip: `hostname -I`

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
if correctly installed this should show the networks: `ip link show`

edit `/etc/network/interfaces`
```bash
auto eth0
iface eth0 inet static
      address 192.168.1.XX/24
      gateway 192.168.1.1
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
