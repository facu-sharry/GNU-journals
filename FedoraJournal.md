# Fedora Installation

# Fedora Journal

## System Information

* **OS:** Fedora Linux 42 (Workstation Edition) x86_64
* **Kernel:** Linux 6.15.10-200.fc42.x86_64
* **Packages:** 2136 (rpm), 6 (flatpak)
* **Shell:** bash 5.2.37
* **DE:** GNOME 48.4
* **WM:** Mutter (Wayland)
* **Terminal:** Ptyxis 48.5

**Hardware:**

* **CPU:** 12th Gen Intel(R) Core(TM) i5-12400 (12) @ 5.60 GHz
* **GPU:** Intel UHD Graphics 730 @ 1.45 GHz [Integrated]
* **Memory:** 5.99 GiB / 7.49 GiB (80%)
* **Swap:** 5.06 GiB / 7.49 GiB (68%)

**Storage:**

* **Disk (/):** 12.68 GiB / 63.93 GiB (20%) - ext4
* **Disk (/home):** 11.73 GiB / 153.56 GiB (8%) - ext4
* **Disk (/mnt/Datos):** 50.35 GiB / 157.76 GiB (32%) - fuseblk
* **Disk (/mnt/Windows_C):** 77.09 GiB / 84.31 GiB (91%) - fuseblk


## Initial Setup
- Installed `gparted` to create the EFI (boot) partition during installation with correct flags (`mkfs` command can be hard)
  ```bash
  sudo dnf install gparted
  ```
- Changed background image
- Imported my printer (worked out of the box, amazing)
- Set up keyboard shortcuts:
  - `Ctrl + Alt + T` = Ptyxis
  - `Super + D` = Hide all windows
  - `Super + S` = Partial screenshot
- Configured Nautilus for remote connections (alternative to WinSCP)
  - go to left-bar -> Network/Red -> bottom input -> ssh://server.ip -> connect
  - after that, go to the desired folder and hit ctrl + D to save the bookmark

## Software Installation

### Opera Browser
[Installation Guide](https://linuxcapable-com.translate.goog/install-opera-on-fedora-linux/?_x_tr_sl=en&_x_tr_tl=es&_x_tr_hl=es&_x_tr_pto=tc)

```bash
# System Update
sudo dnf upgrade --refresh

# Import repo for Opera
sudo rpm --import https://rpm.opera.com/rpmrepo.key

sudo tee /etc/yum.repos.d/opera.repo <<RPMREPO
[opera]
name=Opera packages
type=rpm-md
baseurl=https://rpm.opera.com/rpm
gpgcheck=1
gpgkey=https://rpm.opera.com/rpmrepo.key
enabled=1
RPMREPO

# Install command
sudo dnf install opera-stable -y

# To uninstall:
sudo dnf remove opera-stable
sudo dnf config-manager --set-disable rpm.opera.com_rpm
```

#### Proprietary Codecs
1. Check Opera's Chromium version: `opera://about` (135.0.7049.115)
2. Check ffmpeg version from [nwjs.io/versions.json](https://nwjs.io/versions.json) (98.2)
3. Download proprietary ffmpeg.so:
   ```bash
   wget https://github.com/nwjs-ffmpeg-prebuilt/nwjs-ffmpeg-prebuilt/releases/download/0.98.2/0.98.2-linux-x64.zip
   unzip 0.98.2-linux-x64.zip
   sudo mkdir -p /usr/lib64/opera/lib_extra/
   sudo mv ffmpeg.so /usr/lib64/opera/lib_extra/
   ```
4. Restart Opera

## Other Applications
- Imported bookmarks and open tabs with Export Tabs extension

### CopyQ
- Installed clipboard history:
  ```bash
  sudo dnf install copyq
  ```
  - Configured shortcut: `SUPER + V` for CopyQ (copyq show)
  - Went to copyq -> preferences -> open at startup

### DBeaver
  ```bash
  # Download rpm package from official website and do
  sudo rpm -ivh dbeaver-<version>.rpm
  # To upgrade later:
  sudo rpm -Uvh dbeaver-<version>.rpm
  ```
### GIMP:
  ```bash
  sudo dnf upgrade --refresh
  sudo dnf install gimp
  gimp --version
  ```

## Account Setup
- Logged into:
  - UNC Google account
  - Gmail
  - Trello with UNC account
  - GitHub

## Git Configuration
```bash
sudo dnf install git
git config --global user.name "Facundo Sharry"
git config --global user.email "facundo.sharry@gmail.com"
```

### SSH Setup
[GitHub SSH Guide](https://www.geeksforgeeks.org/git/how-to-add-ssh-key-to-your-github-account)

```bash
mkdir -p ~/.ssh/github
ssh-keygen -t ed25519 -C "github-key" -f ~/.ssh/github/github-key
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/github/github-key
cat ~/.ssh/github/github-key.pub | xclip -selection clipboard
# Paste to GitHub SSH keys
ssh -T git@github.com
git config --global core.sshCommand "ssh -i ~/.ssh/github/github-key"
```

### SSH Config
```bash
touch ~/.ssh/config

printf "# Configuración GENERAL (clave por defecto para todo)\nHost *\n\tAddKeysToAgent yes\n\tIdentitiesOnly yes\n\tIdentityFile ~/.ssh/id_ed25519  # Tu clave general (ej: id_rsa, id_ed25519)\n\n# Configuración ESPECÍFICA para GitHub (usa otra clave)\nHost github.com\n\tHostName github.com\n\tUser git\n\tIdentityFile ~/.ssh/github/github-key" | sudo tee -a ~/.ssh/config
chmod 600 ~/.ssh/config
```

## Development Tools

### VS Code
```bash
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo tee /etc/yum.repos.d/vscode.repo <<EOF
[vscode]
name=packages.microsoft.com
baseurl=https://packages.microsoft.com/yumrepos/vscode/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
metadata_expire=1h
EOF
sudo dnf install code
```

### LAMP Stack
[Installation Guide](https://computingforgeeks.com/how-to-install-lamp-stack-on-fedora)

```bash
# Basic tools
sudo dnf -y update
sudo dnf -y install vim bash-completion curl wget telnet

# Apache
sudo dnf -y install httpd
sudo systemctl start httpd
sudo systemctl enable httpd
sudo firewall-cmd --add-service={http,https} --permanent
sudo firewall-cmd --reload

# PHP
sudo dnf -y install php php-cli php-php-gettext php-mbstring php-mcrypt php-mysqlnd php-pear php-curl php-gd php-xml php-bcmath php-zip php-fpm php-xdebug

# Set up your timezone in php.ini
nano /etc/php.ini
date.timezone = America/Argentina/Cordoba

# Composer
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
sudo chmod +x /usr/local/bin/composer
composer self-update

# MariaDB
sudo dnf install mariadb-server
sudo nano /etc/my.cnf.d/mariadb-server.cnf
# Add: character-set-server=utf8 under [mysqld]

# I will not use mariadb, but if you wanted to, here is how

# Then start the mariadb service (and enable it to start on boot ?)
sudo systemctl start mariadb
sudo systemctl enable mariadb

# Perform MariaDB initial settings like setting up a root password, disabling remote root login e.t.c:
$ sudo mysql_secure_installation 
# test if the service is running correctly
mysql -u root -p 

# We have confirmed that our Database server is working fine. To allow for remote connections, allow port 3306 on the firewall
sudo firewall-cmd --add-service=mysql --permanent
sudo firewall-cmd --reload

# You can also limit access from trusted networks
sudo firewall-cmd --permanent --add-rich-rule 'rule family="ipv4" \
service name="mysql" source address="10.1.1.0/24" accept'
```

### Virtual Host Setup
```bash
sudo touch /etc/httpd/conf.d/test_page.conf
printf "<VirtualHost *:80>\n\tServerName test_page.localhost\n\tDocumentRoot /var/www/html/test_page\n\n\t<Directory /var/www/html/test_page>\n\t\tOptions Indexes FollowSymLinks MultiViews\n\t\tAllowOverride All\n\t\tRequire all granted\n\t</Directory>\n</VirtualHost>" | sudo tee -a /etc/httpd/conf.d/test_page.conf

# restart apache
sudo systemctl restart httpd
sudo systemctl stop
sudo systemctl start
```

## System Configuration

### SELinux Configuration
```bash
sudo setsebool -P httpd_can_network_connect_db 1
sudo setsebool -P httpd_can_network_connect 1

# For custom directories:
sudo semanage fcontext -a -t httpd_sys_content_t "/home/user/www(/.*)?"
sudo restorecon -Rv /home/user/www

# start services
sudo systemctl enable --now httpd mariadb
sudo firewall-cmd --add-service={http,https} --permanent
sudo firewall-cmd --reload

# Common SELinux issues & fixes

Symptom/Solution
Apache can’t access files	
sudo chcon -R -t httpd_sys_content_t /var/www

PHP can’t connect to MySQL	
sudo setsebool -P httpd_can_network_connect_db 1

403 Forbidden errors # THIS HAPPENED TO ME, I DECIDED TO NOT WASTE TIME AND DISABLE IT	
Check audit logs: sudo ausearch -m avc -ts recent
```
### Disable SELinux (recommended only for dev or a very well firewalled server)
```bash
# If we wanted to disable it to not deal with this configuration:
sudo setenforce 0 # THIS ONLY DISABLES IT FOR THE CURRENT SESSION, AFTER REBOOTS IT COMES BACK

# Disable it for good by editing its config file:
sudo nano /etc/selinux/config
# set SELINUX=disabled

# Why Not Disable SELinux Permanently?
Security risk: Services run unrestricted (e.g., Apache could read /etc/shadow if hacked).
```

### File Permissions
#### Useful commands
````bash
# lists all users and its groups
cat /etc/passwd 
cat /etc/group

# lists groups for an user
groups
groups apache

# print info about user and its groups
id
id apache

# list all members of a group
getent group apache
getent group

# create an user that will ssh into the server with limited permissions
sudo useradd username
sudo passwd username

# add user to sudoers
visudo

#add following line:
user   ALL=(ALL)    ALL
````

#### Single user setup
```bash
# 
I have 1 user, dev (puestof01 in my pc), and the apache user apache
The user of everything will be dev and the group will be apache

General Files of my webapp : - rwx r-- ---
Directories of my webapp : - rwx r-x ---
Storage dir : - rwx rwx ---
#

# User + Group ownership
sudo usermod -a -G apache puestof01
sudo chown -R puestof01 /var/www/html
sudo chgrp -R apache /var/www/html

# Set files+directories permissions
find /path/to/parent_directory -type f -exec chmod 740 {} \; # General Files
find /path/to/parent_directory -type d -exec chmod 750 {} \; # Directories
sudo chmod g+rwx -R /var/www/html/web_app/storage/ # Storage dir (make sure to document in every webapp which files need to have apache write permissions)

# additional and useful files to have access to
# Remember which files had apache write permissions first before changing this to avoid breaking LOGS and apache vhosts
sudo chown -R puestof01 /var/log/php-fpm #(Open txt files directly from vscode and not by double-clicking it)
sudo chgrp apache /var/log/php-fpm
sudo chown -R puestof01 /etc/httpd
sudo chown -R puestof01 /var/log/httpd
# if logs dont work maybe you need to
sudo chmod g+rwx -R /var/log/php-fpm
```

#### Multi-user setup (unused)
```bash
sudo groupadd devs-apache
sudo usermod -a -G devs-apache puestof01
sudo usermod -a -G devs-apache apache
sudo chown -R puestof01 /var/www/html
sudo chgrp -R devs-apache /var/www/html

# Set directory permissions
find /path/to/parent_directory -type d -exec chmod 750 {} \;
find /path/to/parent_directory -type f -exec chmod 740 {} \;

# edit httpd.conf
# Set group line to devs-apache

# Restart apache as root
sudo systemctl restart httpd
sudo systemctl stop httpd
sudo systemctl start httpd
sudo systemctl status httpd

```

### System Upgrade
```bash
sudo dnf upgrade --refresh
sudo dnf system-upgrade download --releasever=43
sudo dnf5 offline reboot
```
