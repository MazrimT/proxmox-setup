# Setup Proxmox (pxvirt) on Raspberry PI 5

This is none-proven way to set up Proxmox + Ceph on Raspberry PI 5's using nvme ssd's on each PI.

This is all probably a horrible idea.

Pull this repo any way you see fit or copy the files.

# Hardware used
5x:
- Raspberry Pi 5 8GB
- Waveshare POE M.2 HAT+
- 1TB SSD

Connected through MikroTikC `CSS610-8P-2S+` PoE switch.

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
# this defaults to 1, but most likely we're not going to use a camera
camera_auto_detect=0
# this defaults to 1, but most likely the pi's will not have displays
display_auto_detect=0

# make sure the pi is actively controlling the fan
dtparam=cooling_fan=on
# fan speed control, see below for instructions, this might need modifying
# these settings worked for me to keep the fan as slow as possible but able to speed up when needed
# speed 239 = 90% of max speed.
dtparam=fan_temp0=49000,fan_temp0_hyst=3000,fan_temp0_speed=50
dtparam=fan_temp1=60000,fan_temp1_hyst=3000,fan_temp1_speed=110
dtparam=fan_temp2=70000,fan_temp2_hyst=3000,fan_temp2_speed=170
dtparam=fan_temp3=80000,fan_temp3_hyst=3000,fan_temp3_speed=230

# make sure we're using pciexpress gen 3 for the ssd
dtparam=pciex1_gen=3

# optionally if not using wifi or bluetooth to save a tiny bit of power
# dtoverlay=disable-wifi 
# dtoverlay=disable-bt
```

>[!INFORMATION]
> Fan speed info
> You can control up to 4 settings for fan speed based on temperature starting with 0 (so 0, 1, 2, 3)
> fan_tempX = temperature in millicelsius (so celcius with 3x0 after)
> fan_tempX_hyst = how much far below this to go to previous setting when comming back down in temperature
> fan_tempX_speed = 0 to 255 where 0 is off and 255 is 100% speed.
>
> There is always a "hidden" 0 speed below fan_temp0 so that is the cpu temperature is `fan_temp0 - fan_temp_hyst` then fan speed is automatically set to 0.
>


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
sudo clone/wipe_and_partition_nvme.sh
sudo clone/clone.sh [new_hostname]
```

set what the hostname will be after cloning on the SSD. does not affect the SD-card

remove sd card and reboot


# Proxmox Node setup

setup network stuff
```bash
sudo node_setup/setup_network.sh
```

> [!IMPORTANT]
> IP-address is now static, make sure it's reserved in router

install proxmox
```bash
sudo apt update
sudo DEBIAN_FRONTEND=noninteractive apt install -y proxmox-ve pve-manager qemu-server pve-cluster
```

delete eth0 from the proxmox gui
add new Linux Bridge.
```bash
IPv4/CIDR: 192.168.1.XXX/24    # whatever the IP-address is
Gateway: 192.168.1.1           # or whatever was in the gateway is
Autostart: check
Bridge ports: eth0
``` 
Click `Apply Configuration`

- Create/join cluster.

# Ceph
make sure proxmox works, then install ceph NOT THROUGH WEB GUI!

```bash
sudo apt update
sudo apt install ceph -y
```

Configure in webgui.
network: the linux bridge that was set up

# Monitor temperature and fan speed
There is nothing out of the box in proxmox to monitor nodes cpu temp or fan speed.
Can build something yourself based on the following commands:
```bash
# cpu temperature in millicelcius
cat /sys/class/thermal/thermal_zone0/temp

# fan speed in rpm. 
cat /sys/class/hwmon/hwmon*/fan1_input
```

or run this to get it as a nice json
```bash
jq -n --argjson temp "$(($(cat /sys/class/thermal/thermal_zone0/temp)))" \
      --argjson fan_rpm "$(cat /sys/class/hwmon/*/fan1_input 2>/dev/null | head -1)" \
      --argjson fan_state "$(cat /sys/class/thermal/cooling_device0/cur_state)" \
      '{temperature: $temp, fan_rpm: $fan_rpm, fan_state: $fan_state}'
```
