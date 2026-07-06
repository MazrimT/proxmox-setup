# Setup Proxmox (pxvirt) on Raspberry PI 5

This is none-proven way to set up Proxmox + Ceph on Raspberry PI 5's using nvme ssd's on each PI.

This is all probably a horrible idea.

Pull this repo any way you see fit or copy the files.

# Setup SD-card

- Install Raspberry PI 64-bit bookworm lite. NOT TRIXIE
- use maximum a 64GB SD-card! the partitioning of the drive will be 64GB for root

for full headless setup:
- put an empty file `ssh` in bootfs
- put a fille called `userconf` in bootfs containing:
```
username:encrypted-password
```
make the encrypted password:
```
echo 'mypassword' | openssl passwd -6 -stdin
```


make sure SSD is in gen3 mode:
add to `/boot/firmware/config.txt`
should be directly in the "main" part, not in any section
```bash
dtparam=pciex1_gen=3

# optionally if not using wifi or bluetooth to save a tiny bit of power
# dtoverlay=disable-wifi 
# dtoverlay=disable-bt
```




install rpi-clone
```bash
curl https://raw.githubusercontent.com/geerlingguy/rpi-clone/master/install | sudo bash
```

proxmox requires root user, up a password and keep it safe
```bash
sudo passwd root
```

install ifupdown2
```bash
sudo apt install ifupdown2 -y
```

get keys for pxvirt
```bash
sudo curl -L https://mirrors.lierfang.com/pxcloud/lierfang.gpg -o /etc/apt/trusted.gpg.d/lierfang.gpg
```


make file `/etc/apt/sources.list.d/pxvirt-sources.list`
```bash
deb [arch=arm64] https://mirrors.lierfang.com/pxcloud/pxvirt bookworm main
```

make file `/etc/apt/sources.list.d/pxvirt-ceph.list`
```bash
deb [arch=arm64] https://download.lierfang.com/pxcloud/pxvirt bookworm ceph-squid
```

edit `/etc/apt/sources.list` and add:
```bash
deb http://deb.debian.org/debian bookworm-backports main
```
and after install python3-virt-firmware:
```bash
sudo apt update
sudo apt install python3-virt-firmware
```




# clone
run:
```bash
clone/wipe_and_partition_nvme.sh
clone/clone.sh
```
give it a new hostname
remove sd card and reboot


# Node setup

setup network stuff
```bash
sudo /setup/setup_network.sh
```

> [!IMPORTANT]
> IP-address is now static, make sure it's reserved in router

install proxmox
```bash
sudo DEBIAN_FRONTEND=noninteractive apt install -y proxmox-ve pve-manager qemu-server pve-cluster
```

make sure proxmox works, then install ceph:
```bash
sudo apt install ceph -y
```


