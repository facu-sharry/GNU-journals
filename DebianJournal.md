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
* Created boot partition `/boot` (ext4, boot flag, 1024MB (or more))
* Created swap partition (swap type, swap flag, 8GB)
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

### Custom Shortcuts

* `Super + Shift + S` → interactive screenshot
* `Ctrl + Alt + T` → GNOME Terminal
* `Alt + WASD` → window resizing
* `Super + D` → hide all windows

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

* Installed it through Flatpak in Software App
* Logged in to sync bookmarks with Mozilla account
* Installed RoboForm Extension
* De-hided toolbar bookmarks
* Disabled 'Workspace only essential tabs'

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

### Installed Software

* **Deb:** Thunderbird
* **Flatpak:** Discord, Telegram, Extension Manager
* **GNOME Extensions:** Dash to Dock, Blur My Shell, Caffeine, Clipboard Indicator, Removable Drive Menu, Vitals, DING (Desktop Icons NG)
* **Tweaks:** added minimize/maximize buttons
* **Other:** Shortcut app, GParted, BalenaEtcher, gdisk, GIMP, Krita, Inkscape, KdenLive, OBS

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
