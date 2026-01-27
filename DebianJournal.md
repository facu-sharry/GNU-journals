# Debian Journal

## System Information

* **OS:** Debian GNU/Linux 13 (trixie) x86\_64
* **Kernel:** Linux 6.12.43+deb13-amd64
* **Packages:** 2517 (dpkg), 17 (flatpak)
* **Shell:** bash 5.2.37
* **Display (HDMI-0):** 1600x900 @ 60 Hz \[External]
* **DE:** GNOME 48.4
* **WM:** Mutter (X11)
* **Terminal:** GNOME Terminal 3.56.2

**Hardware:**

* **CPU:** Intel(R) Core(TM) i7-7700K (8) @ 4.50 GHz
* **GPU:** NVIDIA GeForce GTX 1050 Ti \[Discrete]
* **Memory:** 9.59 GiB / 15.58 GiB (62%)
* **Swap:** 0 B / 7.45 GiB (0%)

**Storage:**

* **Disk (/):** 128.13 GiB / 211.22 GiB (61%) - ext4
* **Disk (/mnt/HDDBLACK):** 463.76 GiB / 465.76 GiB (100%) - fuseblk \[Read-only]
* **Disk (/mnt/WINDOWS):** 107.50 GiB / 111.03 GiB (97%) - fuseblk \[Read-only]

---

## Installation Process

* Chose **manual installation**
* Selected SSD for installation
* Created boot partition `/boot` (ext4, boot flag, 2048MB (or more))
* Created swap partition (swap type, swap flag, 8GB)

* Now, depending on your needs, create other partitions (like `/home`), or just go to next step
* That depends if you are going to have many 'local' installation and user data, or if you are going to install things system wide and store data in other drives, in my case, i donw know how many installations im going to do or where they will be stored so i leave everything in `/`. Choosing `home` size accordingly is painful if you dont know your future needs, but is recommended in case system partition breaks and you dont want to lose personal data. 

* Created `/` partition (ext4, all remaining space)
* Installed: Debian desktop environment + GNOME + basic system tools

  * (*Next time*: exclude GNOME, try Hyprland instead)

---

## First Steps & Configuration

* Enabled **night light** & **performance mode**
* Keyboard: English (US) + Spanish (LatAm)
* Timezone: UTC-3
* Nautilus preferences: “Sort folders before files”
* Disabled mouse acceleration
* Terminal -> Preferences -> profile -> Initial Terminal Size: 120 columns x 35 rows
                                      -> Color scheme: GNOME

### Custom Shortcuts

* `Super + Shift + S` → interactive screenshot
* `Ctrl + Alt + T` → GNOME Terminal
* `Alt + WASD` → window resizing
* `Super + D` → hide all windows
* `Shift + Alt + AD` → move window to left/right monitor

### Personalization

* Changed background & profile picture
* Added user to sudoers via `visudo`
   ```bash
   su
   sudo usermod -aG sudo username
   sudo reboot
   
   (as your user)
   sudo visudo /etc/sudoers
   
   add lines: '
   youruser    ALL=(ALL) NOPASSWD:ALL
   '
   ```
* Updated system with `apt update && apt upgrade`

---

## Disk Management

* Used **Disks** app for automatic mounts
* Select desired disk
* Click Additional partition options (ruedita)
* Click 'Edit Mount Options'
* Disable User defaults
* Edit Mount Point to a recognizible name
* Save

---

## Accounts

* Netflix (enabled DRM)
* Google (unc.edu.ar + gmail.com)
* Github
* Whatsapp

---
## Zen Browser Setup

* Installed it through Flatpak in Software App (if flatpak not yet installed see next step)
* Logged in to sync bookmarks with Mozilla account
* Installed RoboForm Extension
* De-hided toolbar bookmarks
* Disabled 'Workspace only essential tabs'
* Enabled 'Ask where to save downloads'

---

## Flatpak Installation

```bash
sudo apt install flatpak
```
```bash
sudo apt-get --reinstall install -y gnome-software-plugin-flatpak
```
```bash
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
```

---

## OS Tweaks

* Removed unused software (Sound Recorder, Mail, Music, GNOME Tour, Videos)
* Added non-free repos (just in case, only for nvidia drivers probably): `contrib non-free` to `/etc/apt/sources.list` after every `main` appearance
* Installed essentials with apt: `fastfetch`, `htop`, `btop`, `curl`
* Added fastfetch at every terminal except vscode
  ```bash
    nano ~/.bashrc

    # add the following lines

    if [ "$TERM_PROGRAM" != "vscode" ]; then
        fastfetch
    fi
  ```

### Before installing things:

* Try installing everything first with sudo
* That way, software will be shared between users and system wide
* Only if not available, install through flatpak or other methods
* Try using flatpak with the `--system` flag to install system wide
* In the software app, choose 'for all users' when installing through flatpak
* In case of appimages, create a folder at `/opt/appimages` and place them there with proper permissions
* In case of compiling from source, install to `/usr/local` instead of home folder
* desktop files should be placed at `/usr/share/applications` for system wide availability instead of `~/.local/share/applications`

### Installed Software through Software App

* **Deb:** Thunderbird, Xournal++
* **Flatpak:** Discord, Telegram, Extension Manager
* **GNOME Extensions:** Dash to Dock, Blur My Shell, Caffeine, Clipboard Indicator, Removable Drive Menu, Vitals, DING (Desktop Icons NG)
* **Tweaks:** added minimize/maximize buttons
* **Other:** Shortcut app, GParted, BalenaEtcher, gdisk, GIMP, Krita, Inkscape, KdenLive, OBS

### Other installed software

#### npm and nvm
```bash
sudo apt install npm nvm
```
#### angular cli
```bash
sudo npm install -g  @angular/cli
````

#### Git and ssh key for github

* Install Git 
```bash
sudo apt install git
```
* Set up username and email
```bash
git config --global user.name "Facundo Sharry"
git config --global user.email "facundo.sharry@gmail.com"
```
* Generate key
```bash
mkdir -p ~/.ssh/github
ssh-keygen -t ed25519 -C "github-key" -f ~/.ssh/github/github-key
```
* Add ssh key to ssh agent
```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/github/github-key
```
* Copy ssh public key
```bash
sudo apt install xclip
cat ~/.ssh/github/github-key.pub | xclip -selection clipboard
```
* Add the ssh key in the github configuration "ssh keys" menu
* Test if the connection is working
```bash
ssh -T git@github.com
```
* If so, set the ssh key as the default for every ssh operation
```bash
git config --global core.sshCommand "ssh -i ~/.ssh/github/github-key"
```
---

## Nvidia video driver Installation

* Use proper NVIDIA setup: (https://wiki.debian.org/NvidiaGraphicsDrivers#Debian_13_.22Trixie.22)
  * In case that you broke the system trying to install nvidia drivers before, do a cleanup with:
    ```bash
    sudo apt purge nvidia-* libnvidia-*
    sudo apt autoremove
    sudo apt clean
    ```
  * Blacklisted Nouveau
    ```bash
    sudo touch /etc/modprobe.d/blacklist-nouveau.conf
    sudo nano /etc/modprobe.d/blacklist-nouveau.conf
    ```
    Add these lines:
    ```
    blacklist nouveau
    options nouveau modeset=0
    ```
  * Update initramfs:
    ```bash
    sudo update-initramfs -u
    ```
  * Install Linux Headers
    ```bash
    sudo apt install linux-headers-$(dpkg --print-architecture)
    ```
  * Installed `nvidia-kernel-dkms nvidia-driver firmware-misc-nonfree`
  * Rebuilt kernel modules
    ```bash
    sudo dpkg-reconfigure nvidia-kernel-dkms
    ```
  * Rebooted and configured with NVIDIA X-server + correct resolution in Gnome Config

---

## Gaming Setup (https://www.youtube.com/watch?v=vlV26V8yE1A https://www.youtube.com/watch?v=NUjQDl1xzGs)
### Steam installation
* go to steam page https://steamcommunity.com/ and download .deb
* install with
* sudo dpkg -i <name>.deb
* then press enter twice for installing all missing dependencies

### [Battle Net Installation through Steam](https://www.youtube.com/watch?v=wwT-VocQuKc)
* Download .exe installer through battle net offical website
* Go to steam library -> add non-steam game -> choose installer
* Continue with the installation of the battle net launcher, make sure you install it in another drive so you can find it later, Z: is the linux disk, C: is a mounted folder in ~/.steam/steamapps/.../.../userdata/.../C/... (something like that), i created a "Blizzard" folder at ~ and installed it there.
* Next, remove the installer from the steam library
* add non-steam game -> choose Battle Net Launcher
* Second click at Battle Net Launcher -> Compatibility Options -> Use LTS Proton
* Now open the launcher as any steam "game" and install the games you want to play

### RetroArch (All in one emulator) installation
* Install using flatpak
```bash
flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
sudo flatpak install org.libretro.RetroArch
```
* You can finde the desktop icon in
  * /var/lib/flatpak/exports/share/applications/org.libretro.RetroArch.desktop
  * Copy it to ~/Desktop if you want a desktop icon
* or 
* Install using debian's official packages
```bash
sudo apt install retroarch
```
* Verify installation
```bash
retroarch --version
retroarch
```
* Set up ROMS
* Create a folder for roms at ~/Games/ROMS/
```bashmkdir -p ~/Games/ROMS/RetroArch
```
* Download roms from trusted sources
* Open RetroArch, go to Load Content -> Select File And Detect Core -> select the rom you want to play

* Enable RetroAchievements
  * Go to Settings -> Achievements -> Enable RetroAchievements
  * Create an account at https://retroachievements.org/
  * Go to Settings -> Achievements -> Set your username and password
  * Restart RetroArch

* Since cores are not available by debian official packages guidelines, install them through apt: (example of some cores)
```bash
sudo apt install retroarch \
  libretro-nestopia \
  libretro-snes9x \
  libretro-mgba \
  libretro-fceumm
```
* Enjoy!
### SNES emulator installation
* Install FCEUX (official repo)
```bash
sudo apt install fceux
```
* Verify installation
```bash
fceux --version
fceux
```
### Set up ROMS
* Create a folder for roms at ~/Games/ROMS/SNES
```bash
mkdir -p ~/Games/ROMS/SNES
mkdir -p ~/Games/ROMS/NES
```
* Download roms from trusted sources
* Open FCEUX, go to File -> Open ROM and select the rom you want to play

### Sprite editor installation
* Install Aseprite through github build
* Clone Aseprite repo
```bash
git clone git@github.com:aseprite/aseprite.git
cd aseprite
git submodule update --init --recursive
```
* Extract the downloaded file
* Install dependencies
```bash
sudo apt install cmake ninja-build
sudo apt-get install libxcb1-dev
sudo apt install \
  python3 \
  python-is-python3 \
  build-essential \
  cmake \
  ninja-build \
  clang \
  libx11-dev \
  libxcursor-dev \
  libxi-dev \
  libgl1-mesa-dev \
  libfontconfig1-dev \
  libxinerama-dev \
  libxrandr-dev \
  libgtk-3-dev \
  libssl-dev \
  libcurl4-openssl-dev \
  zlib1g-dev
```
```bash
* Build Aseprite
```bash
./build.sh
```
* Run Aseprite
```bash
./bin/aseprite
```
---

## Extras
### Driver problems
* Installed NVIDIA drivers via Synaptic (`firmware-nvidia-gsp 550`) (OPTIONAL, its not confirmed that this is neccessary in any way)
* Broke system trying `nvidia-smi` → fixed by purging NVIDIA, reinstalling Nouveau.
  * How to purge nvidia and reinstall Nouveau video driver:
  ```bash
   # ENTER TERMINAL INSTANCE: CTRL + ALT + F3
   sudo apt purge nvidia-smi
   sudo apt remove --purge '^nvidia-.*'
   sudo apt install xserver-xorg-video-nouveau
   sudo dpkg-reconfigure xserver-xorg
   sudo reboot
  ```
### Gaming setup
### Wine installation (https://gitlab.winehq.org/wine/wine/-/wikis/Debian-Ubuntu)
```bash
sudo dpkg --add-architecture i386 
sudo mkdir -pm755 /etc/apt/keyrings
wget -O - https://dl.winehq.org/wine-builds/winehq.key | sudo gpg --dearmor -o /etc/apt/keyrings/winehq-archive.key -
sudo wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/trixie/winehq-trixie.sources
sudo apt update
sudo apt install --install-recommends winehq-staging
```
### Lutris installation (from openSUSE repo) (https://lutris.net/downloads https://www.youtube.com/watch?v=vlV26V8yE1A)
```bash
echo -e "Types: deb\nURIs: https://download.opensuse.org/repositories/home:/strycore/Debian_12/\nSuites: ./\nComponents: \nSigned-By: /etc/apt/keyrings/lutris.gpg" | sudo tee /etc/apt/sources.list.d/lutris.sources > /dev/null
wget -q -O- https://download.opensuse.org/repositories/home:/strycore/Debian_12/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/lutris.gpg
sudo apt update
sudo apt install lutris
```
* In Case Lutris doesnt let you install BattleNet or other games as i could not, set up ProtonPlus for Battle.net workaround (change wine and proton versions) (https://forums.lutris.net/t/last-battle-net-installer-not-working/23063) (https://www.reddit.com/r/cachyos/comments/1ke6tea/battlenet_via_lutris_failing_to_reinstall/)
* Or, you could install Battle Net through Steam (https://www.youtube.com/watch?v=wwT-VocQuKc)

--

## Final Notes

* In case of dual boot and your 2nd system not beign read, run `sudo update-grub`
* Avoid blindly installing NVIDIA drivers without checking Debian Wiki

---
