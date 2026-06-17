# Debian Server Journal

## Installation
- Downloaded Debian ISO from oficial repository
- Created bootable USB with Ventoy
- Installed Debian with default options, no graphical installation, no additional software, no partitioning, no encryption, no LVM, no RAID, no network configuration (DHCP), no user creation (root password only)

## Post-Installation
- Updated system with `sudo apt update && sudo apt upgrade -y`
- Installed OpenSSH Server with `sudo apt install openssh-server`
- Enabled SSH service with `sudo systemctl enable ssh`
- Started SSH service with `sudo systemctl start ssh`
- Configured static IP address by editing `/etc/network/interfaces` and adding:
```
auto eth0
iface eth0 inet static
    address