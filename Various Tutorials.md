# Various Tutorials

## Godot

* Download Godot Engine from the [official website](https://godotengine.org/download).

pollo@pollo-new:/usr/local/bin$ ls ~/Downloads/
Godot_v4.6-stable_linux.x86_64.zip  gparted-live-1.7.0-12-amd64.iso  linux-portable-latest.AppImage  steam_latest.deb

* Decompress the downloaded file
* Move the executable to `/usr/local/bin` for system-wide access
```bash 
sudo mv ~/Downloads/Godot_v4.6-stable_linux.x86_64 ./godot 
```

* Create desktop entry for Godot
```bash
sudo mkdir -p /usr/local/share/applications
cd /usr/local/share/applications
sudo nano /usr/local/share/applications/godot.desktop
```

* Add the following content to the `godot.desktop` file:
```ini
[Desktop Entry]
Name=Godot
Comment=Godot Game Engine
Exec=/usr/local/bin/godot
Icon=godot
Terminal=false
Type=Application
Categories=Development;Game;
```

* Make the desktop entry executable
```bash
sudo chmod a+x godot.desktop 
```

* Copy the Godot icon to the appropriate directory
```bash
sudo mkdir -p /usr/local/share/icons/hicolor/256x256/apps
sudo cp ~/Downloads/godot.png /usr/local/share/icons/hicolor/256x256/apps/godot.png
sudo update-desktop-database
```

## Eden Emulator

* With the help of this tutorial [How to Install Eden on Linux](https://www.youtube.com/watch?v=BdLoPSxkZKo)

* Download the latest Eden Emulator deb package from the [official website](https://eden-emu.dev/download).

* Install the downloaded package using `dpkg`
```bash
sudo dpkg -i ~/Downloads/eden-emulator-*.deb
```

* If there are dependency issues, fix them using:
```bash
sudo apt-get install -f
```

* Launch Eden Emulator from the application menu or via terminal:
```bash
eden-emulator
```

* Download Firmware and Keys
    - Right now this is the links i use (28/01/2026):
        - [Firmware](https://github.com/THZoria/NX_Firmware/releases/)
        - [Keys](https://prodkeys.net/yuzu-prod-keys-n27/)

* How to install them:

    - Where Eden stores its data (Linux)
    - After first launch, Eden uses:
    ``` ~/.local/share/eden/ ```
    - Inside that:
        ~/.local/share/eden/
        ├── keys/
        │   └── prod.keys
        ├── nand/
        │   └── system/
        │       └── Contents/
        │           └── registered/   ← firmware files go here
        ├── cache/
        ├── logs/
        └── config/

    - First, install the keys
        - Copy the `prod.keys` file to the `keys` folder
        - The `title.keys` file is optional, but you can add it if you have it
    - Then, install the firmware
        - Go to Eden
        - Tools -> Install Firmware -> select ZIP file you downloaded
    - 🧪 How to verify Eden sees them
        Inside Eden:
        Emulation → Configure → System
        You should see:
        ✅ Keys loaded
        ✅ Firmware version detected
        If firmware shows “None” → it’s not in the right place.

* Install games from various sources like
    - https://fmhy.net/gaming#nintendo-roms
    - https://taodung.com/
    - https://switchroms.io/
    - https://t.me/NSW_TorrentLibrary

### If downloading nsz compressed files, do this to decompress ->

* Go to ~ and install nsz
`sudo apt update`
`sudo apt install python3 python3-pip git`
`sudo apt install python3.13-venv`
`python3 -m venv nsz-env`

* Activate python virtual enviroment 
`source nsz-env/bin/activate`
* Install nsz with pip
`pip install nsz`
* Add keys.txt and prod keys to /home/pollo/nsz-env/bin/keys.txt or /home/pollo/.switch/prod.keys
`mkdir -p .switch`
`cp .local/share/eden/keys/prod.keys .switch/prod.keys`
`nsz -D \<path-to-nsz-file\>`
* When done, deactivate virtual enviroment
`deactivate`

### Installing mods

* Download a mod from the source of choice

* Mods come in various formats, but they always contain folders like `romfs`, `exefs`, `sdmc`, etc. These folders need to be merged with the corresponding folders in the game directory.

* For example: if you dowload 60fpsMOD for BotW, you will get a folder with `romfs` and `exefs` folders. You need to copy this mod folder, go to the 'mods' folder of the game, and paste it there. Then, when you launch the game with Eden, it will load the mod files from the 'mods' folder and apply them to the game.

* The final directory would look like this:

```~/.local/share/eden/
├── keys/
│   └── prod.keys
├── nand/
│   └── system/
│       └── Contents/
│           └── registered/
├── cache/
├── logs/
├── config/
└── load/
    └── <game-id>/
        └── <mod-name>/
            ├── romfs/
            ├── exefs/
            └── sdmc/
    └── <game-id>/
        └── <mod-name>/
            ├── romfs/
            ├── exefs/
            └── sdmc/
    ...
```
