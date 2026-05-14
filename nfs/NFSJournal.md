## NFS Server Installation

sudo apt update
### Install
sudo apt install nfs-kernel-server

### Start
sudo systemctl start nfs-kernel-server.service

### Utils
#### Discover available NFS shares (in the server)
cat /etc/exports

#### Discover IPS
ip addr
hostname -I

### Define folders to be shared and to what IP/Range
sudo vi /etc/exports

#### You can add the following lines as example
/path_to_shared_folder client_IP(rw,sync,no_subtree_check,no_root_squash)

Export options explained

    rw: Read-write access
    ro: Read-only access (use instead of rw if you prefer)
    sync: Write changes to disk immediately
    no_subtree_check: Improves performance (recommended)
    root_squash: Maps root user requests to anonymous user (default, safer) (need to configure user and group later, not of use if you want to share entire filesystems owned by root)
    no_root_squash: Allows root access (less secure)
    
#### Apply configurations
sudo exportfs -a

(a mi no me anduvo con -a asi que sin -a me tiro un output aunque sea)

#### If needed
sudo systemctl restart nfs-kernel-server


#### Read-Only filesystem bug (fast boot fixed in nfs client installation)
sudo systemctl stop nfs-kernel-server
mount | grep -E "HDDBLACK"
sudo mount -o remount,rw /mnt/HDDBLACK/

#### error
The disk contains an unclean file system (0, 0).
Metadata kept in Windows cache, refused to mount.
Falling back to read-only mount because the NTFS partition is in an
unsafe state. Please resume and shutdown Windows fully (no hibernation
or fast restarting.)
Could not mount read-write, trying read-only

## NFS Client Installation
sudo apt install nfs-common
(enter when prompted, leave empty)
sudo mkdir -p /mnt/pc2/disk1
sudo mount SERVER_IP:/mnt/disk1 /mnt/pc2/disk1
sudo mount | grep -i nfs
ls -la /mnt/pc2/disk1

touch /mnt/pc2/disk/test.txt
mount | grep nfs

pollo@pollo-new:~$ sudo umount --force /mnt/pc2/disk1

sudo mkdir -p /mnt/pc2/HDDBLACK
sudo mkdir -p /mnt/pc2/HDDBLUE
sudo mkdir -p /mnt/pc2/WINDOWS
sudo mount SERVER_IP:/mnt/HDDBLACK /mnt/pc2/HDDBLACK
sudo mount SERVER_IP:/mnt/HDDBLUE /mnt/pc2/HDDBLUE
sudo mount SERVER_IP:/mnt/WINDOWS /mnt/pc2/WINDOWS


#### FIX WINDOWS FAST BOOT
EN WINDOWS IR A 

Control Panel -> Hardware and Sound -> Power Options -> Choose what the power off button does -> Enable unavailable options -> Turn off FAST BOOT
CMD as administrator -> powercfg.exe /hibernate off

#### Make mount permanent (NOT RECCOMMENDED, IT CAN CAUSE BOOT PROBLEMS IF THE SERVER IS NOT AVAILABLE)
sudo nano /etc/fstab
add this lines
server_IP:/mnt/shared /mnt/nfs_shared nfs defaults 0 0

sudo mount | grep -i nfs

#### FIX 'ENTER AUTH USERNAME' WHEN BOOTING

0- The solution was removing the 'mount' fstab entries, i did the option 2 anyway and it didnt work i think because nfs continues to work even after disabling all of its services including rpc what the fuck.

1- reinstall with 
sudo apt remove nfs-common
sudo apt install nfs-common --no-install-recommends

2- 

sudo systemctl status rpc-statd
○ rpc-statd.service - NFS status monitor for NFSv2/3 locking.
     Loaded: loaded (/usr/lib/systemd/system/rpc-statd.service; static)
     Active: inactive (dead)
       Docs: man:rpc.statd(8)
pollo@pollo-new:~$ sudo systemctl stop rpc-statd
pollo@pollo-new:~$ sudo systemctl disable rpc-statd
The unit files have no installation config (WantedBy=, RequiredBy=, UpheldBy=,
Also=, or Alias= settings in the [Install] section, and DefaultInstance= for
template units). This means they are not meant to be enabled or disabled using systemctl.
 
Possible reasons for having these kinds of units are:
• A unit may be statically enabled by being symlinked from another unit's
  .wants/, .requires/, or .upholds/ directory.
• A unit's purpose may be to act as a helper for some other unit which has
  a requirement dependency on it.
• A unit may be started when needed via activation (socket, path, timer,
  D-Bus, udev, scripted systemctl call, ...).
• In case of template units, the unit is meant to be enabled with some
  instance name specified.
sudo systemctl mask rpc-statd

sudo systemctl disable nfs-client.target
Removed '/etc/systemd/system/multi-user.target.wants/nfs-client.target'.
Removed '/etc/systemd/system/remote-fs.target.wants/nfs-client.target'.
sudo systemctl stop nfs-client.target
sudo umount /mnt/pc2/SSD-120-WIN 
umount.nfs4: /mnt/pc2/SSD-120-WIN: device is busy
sudo umount --force /mnt/pc2/SSD-120-WIN 
umount.nfs4: /mnt/pc2/SSD-120-WIN: device is busy
sudo umount --force /mnt/pc2/SSD-120-WIN 
sudo umount --force /mnt/pc2/SSD-120-WIN 
sudo systemctl stop rpcbind
Stopping 'rpcbind.service', but its triggering units are still active:
rpcbind.socket
sudo systemctl stop rpc-statd
sudo umount --force /mnt/pc2/SSD-120-WIN 
sudo systemctl start rpcbind
sudo systemctl start rpcbind
sudo systemctl stop nfs-mountd
Failed to stop nfs-mountd.service: Unit nfs-mountd.service not loaded.
sudo service nfs-common stop
sudo umount --force /mnt/pc2/SSD-120-WIN 
umount.nfs4: /mnt/pc2/SSD-120-WIN: device is busy
sudo umount /mnt/pc2/SSD-120-WIN 
sudo systemctl status nfs-common
○ nfs-common.service
     Loaded: masked (Reason: Unit nfs-common.service is masked.)
     Active: inactive (dead)
sudo systemctl disable nfs-common