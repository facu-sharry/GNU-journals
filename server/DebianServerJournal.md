# Debian Server Journal

## Installation
- Downloaded Debian ISO from oficial repository
- Created bootable USB with Ventoy
- Installed Debian with default options, no graphical installation, no additional software, no partitioning, no encryption, no LVM, no RAID, no network configuration (DHCP), no user creation (root password only)

## Post-Installation
### Make server user capable of using sudo:
```bash
su -
apt update
apt install sudo
adduser pserveru sudo
```
- Log out completely and thest with:
```bash
sudo whoami
```

### Updated system with `sudo apt update && sudo apt upgrade -y`

### SSH Configuration
- Installed OpenSSH Server with `sudo apt install openssh-server`
- Enabled SSH service with `sudo systemctl enable ssh`
- Started SSH service with `sudo systemctl start ssh`

- In a local machine different than the server, connected to the server via SSH with `ssh server_user@<server-ip-address>`
- Then enter root mode with 'su -'

- If you dont have an user, enter directly as root with `ssh root@<server-ip-address>`, but maybe you will have to create ssh keys first to avoid password authentication and enable root login in `/etc/ssh/sshd_config` by setting `PermitRootLogin yes` and restarting ssh service with `sudo systemctl restart ssh`

### Network Configuration
- You can set a static IP address for your server by editing the `/etc/network/interfaces` file. Here is an example configuration for a static IP address (replace the values with your own):

- First make a backup of the original file with `sudo cp /etc/network/interfaces /etc/network/interfaces.bak`

- Next, configure static IP address by editing `/etc/network/interfaces` and adding (asuming eht0 interface, change it if you have a different one):
- Change that interface’s DHCP stanza to a static one. For example, if the interface is enp1s0, the current address is 123.123.99/24, and ip route shows default via 123.123.1:

```
auto eth0 # This line indicates that the interface eth0 should be automatically brought up at boot time. It ensures that the network interface is activated when the system starts.
iface eth0 inet static # This line specifies that the interface eth0 should use a static IP configuration. Instead of using DHCP to obtain an IP address automatically, it will use the static settings provided below.
    address 123.123.99/24 # Replace with your desired static IP address and the correct subnet mask, this means: 123.123.99 with 24 bits for the network portion (255.255.255.0).
    netmask 255.255.255.0 # Not necessary if you use CIDR notation (address/number)in the address line, but can be included for clarity.
    gateway 123.123.1 # Replace with your default gateway IP address, which is usually the IP address of your router.
    dns-nameservers 8.8.8.8 8.8.4.4 # Replace with your preferred DNS servers. You can use public DNS servers like Google's or Cloudflare's, or your ISP's DNS servers.
```
- Restarted networking service with `sudo systemctl restart networking`

- Useful commands:
    - `ip addr` - Show IP addresses
    - `ip route` - Show routing table
    - `cat /etc/resolv.conf` - Show DNS servers
    - `ip link` - Show network interfaces
    - `systemctl is-active systemd-networkd NetworkManager networking` - Check if networking services are active
    - `networkctl status` - Show network status

### System Monitoring
- Installed btop with `sudo apt install btop` (first run `sudo apt update`)
- Installed lm-sensors with `sudo apt install lm-sensors` and run `sudo sensors-detect` to detect hardware sensors
- When prompted to probe the I2C/SMBus adapters, answer "NO" to avoid potential issues with certain hardware.
- Finally, add the following line to your `/etc/modules` file to ensure that the detected sensor modules are loaded at boot:
```
# Add the following line to /etc/modules
detected_sensor_module_name
```
- Then, run `sudo systemctl restart lm-sensors` to apply the changes and start monitoring your hardware sensors with `sensors` command or with `btop` for a more user-friendly interface.

### Check disk health
- `lsblk -o NAME,SIZE,MODEL,TYPE,MOUNTPOINTS` - Show disk information
- Install smartmontools with `sudo apt install smartmontools`
- sudo smartctl -H /dev/sda
- sudo smartctl -a /dev/sda

### Install fastfetch



### Extras:

### Stuck on apt upgrade
- Check any repository issues with, (for example for the deb repository):
```bash
ping -c 4 deb.debian.org
```
- If you have a problem with the repository, you can change it in `/etc/apt/sources.list` to a different mirror, for example:
```
deb http://ftp.debian.org/debian/ bookworm main contrib non-free
deb http://ftp.debian.org/debian/ bookworm-updates main contrib non-free
deb http://security.debian.org/debian-security bookworm-security main contrib non-free
```

> The problem ended up being a DNS or network issue, so i had to restart the network service with `sudo systemctl restart networking` and then run `sudo apt update && sudo apt upgrade -y` again. This eventually breaks again, so for now we keep troubleshooting till we find the root cause.

- Trying to fix it by connecting a wifi adapter.

> First thing i see when connecting it it says "failed to load firmware".

> fix commands:

```lsusb```
```sudo dmesg -T | grep -iE 'firmware|wlan|wifi|rtl|mt76|ath'```

> Given the output of the previous command, i can see that the wifi adapter is a Realtek device, so i need to install the firmware-realtek package. If other devices are used, you may need to install the corresponding firmware package.

```sudo apt update```

``` sudo apt install firmware-realtek ```

> Connect and reconnect the wifi adapter, then check with `sudo dmesg -T | grep -iE 'firmware|wlan|wifi|rtl|mt76|ath'` to see if it loads the firmware correctly.

> Next, check if the wifi interface is up with `ip addr`.

> Edit the /etc/network/interfaces file to add the wifi interface configuration. (or just follor the Network Configuration section below)

> If both the old and new interfaces are UP, then you can bring down the old one with:

```sudo ip addr flush dev <old-interface>```
```sudo ip link set <old-interface> down```

> Then, restart networking service and reboot to make sure the changes persist and the system is stable.

```ip route show``` should 

