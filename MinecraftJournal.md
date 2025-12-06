# Minecraft Journal
## Step 1: Installation of Dependencies

### Java

- Minecraft requires Java to run. You can install OpenJDK, which is an open-source implementation of the Java Platform.

- For Debian/Ubuntu-based systems, the most recommended version is AdoptOpenJDK. We will install the latest version (25) You can install it this way

- First, download the AdoptOpenJDK 25 package from the official website (https://adoptium.net/)
(this downloads a tar.gz containing openJDK 25)
- Next, install it using the terminal:
```bash
sudo apt update
sudo mkdir -p /usr/lib/jvm
sudo tar -xvf OpenJDK25U-jdk_x64_linux_hotspot_25.0.1_8.tar.gz -C /usr/lib/jvm
```
- Register Java with update-alternatives:
```bash
sudo update-alternatives --install /usr/bin/java java /usr/lib/jvm/jdk-25.0.1+8/bin/java 1
sudo update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/jdk-25.0.1+8/bin/javac 1
sudo update-alternatives --config java
sudo update-alternatives --config javac
```

- Verify the installation:
```bash
java -version
javac -version
```

#### Changing versions in the future
Whenever you install another JDK (like Java 17, Java 21, etc.):

Extract it

Move it to /usr/lib/jvm/whatever-version

Register it:

sudo update-alternatives --install /usr/bin/java java /usr/lib/jvm/jdk-21/bin/java 2
sudo update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/jdk-21/bin/javac 2


Switch versions:

sudo update-alternatives --config java
sudo update-alternatives --config javac


That’s it.

🔥 Example: listing every installed java
update-alternatives --list java

## Step 2: Download Minecraft
### SKLauncher (Recommended)
- SKLauncher is a popular third-party Minecraft launcher that allows you to play different versions of Minecraft, including modded versions. You can download it from the official website: https://sklauncher.org

- Move the downloaded jar file to a desired location, for example, `~/Games/`

```bash
mkdir -p ~/Games
mv ~/Downloads/SKLauncher-<version>.jar ~/Games/
```

- After downloading the jar file, you can run it using the terminal:
```bash
java -jar SKLauncher-<version>.jar
```
- To create a desktop shortcut, you can create a `.desktop` file in `~/.local/share/applications/` with the following content:
```ini
echo "
[Desktop Entry]
Name=SKLauncher
Comment=Minecraft Launcher
Exec=java -jar /path/to/SKLauncher-<version>.jar
Icon=/path/to/icon.png
Terminal=false
Type=Application
Categories=Game;Entertainment;" > ~/.local/share/applications/sklauncher.desktop
```