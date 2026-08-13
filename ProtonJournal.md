# Proton Journal

A journal about Proton.

## Logging in to Proton requires a Proton account. If you don't have one, you can create it [here](https://proton.me/).

After logging in, you can access your Proton account and manage your subscriptions, payments, and other account settings.

This journal will cover various topics related to Proton, including updates, features, and tips for using the service effectively. Mainly the installation of the Proton apps in Linux.

Proton offers the following apps:

* Proton VPN: A virtual private network service that encrypts your internet connection and protects your online privacy.
* Proton Drive: A cloud storage service that allows you to securely store and share files with end-to-end encryption.
* Proton Mail: A secure email service that provides end-to-end encryption for your emails.
* Proton Calendar: A calendar application that allows you to schedule events and appointments with end-to-end encryption.
* Proton Pass: A password manager that allows you to securely store and manage your passwords with end-to-end encryption.
* Some extras but i dont care really much

The Free Plan includes most of them but with limited use, i intend to hire the Proton Duo Plan which includes all of them with more features and storage for only $20~/month.

But first, i need to know how to install them in Linux, so i will be doing some tests and write down the steps here.

### Proton VPN

I found this official tutorial by proton on how to install it [link](https://protonvpn.com/support/official-linux-vpn-debian)

There are three ways to use Proton VPN on Linux:
1. Proton VPN Linux GUI app

The official Proton VPN Linux GUI app (with a graphic user interface) has an intuitive and easy-to-use graphical interface. 

    [How to install the Linux GUI app](https://protonvpn.com/support/official-linux-vpn-debian#install-the-linux-gui-app)
    [How to use the Linux GUI app](https://protonvpn.com/support/use-linux-gui)

2. Proton VPN Linux CLI

The Proton VPN CLI (command-line utility) runs from the Linux terminal.

    [How to install the Linux CLI](https://protonvpn.com/support/linux-cli)
    [How to use the Linux CLI](https://protonvpn.com/support/use-linux-cli#location)

3. Manual configuration

You can manually configure Proton VPN on Linux using: 

    [WireGuard® (recommended whenever possible)](https://protonvpn.com/support/wireguard-linux)
    [OpenVPN (for legacy devices)](https://protonvpn.com/support/linux-openvpn/)

After following the first tutorial i got it working, just run the app, login and it works

### Proton Drive

To this date (10/8/2026) there is not an official Proton Drive app for Linux, there is currently 3 ways of using Proton Drive on Linux:

- You can use the web version at [https://drive.proton.me/](https://drive.proton.me/)

- You can use the unofficial Proton Drive app for Linux, which is available on GitHub. You can find the installation instructions and download links [here](https://github.com/donniedice/protondrive-linux)

- You can use the OFFICIAL Proton Drive CLI (command-line utility) which is available on GitHub. You can find the installation instructions and download links [here](https://proton.me/support/drive-cli) 

- There is a last hidden option: rclone, which is a command line program to manage files on cloud storage. It supports Proton Drive and can be used to automate backups and file synchronization. You can find more information about rclone [here](https://rclone.org/). and a tutorial for the proton backend [here](https://rclone.org/protondrive/)

I decided to try the unofficial Proton Drive app for Linux (update: their github page is bugged, i cant download it)

I will install the CLI also when i need to automate backups and stuff, (the GUI app should be enough).

#### How to access the Proton Drive CLI

    Download Proton Drive CLI for your device. It runs on macOS, Windows, and Linux.
    Open a console / command prompt in the directory where you downloaded the CLI.
    Run ./proton-drive auth login to authenticate via your browser.

Optionally you can move the proton-drive binary to a directory in your PATH, such as /usr/local/bin, so you can run it from anywhere.

* I realized that the CLI does not support synchronization and does not support checksum verification, so i cant use it like i used to use google drive, i need to upload a backup of my drive to the cloud, i need it to not be synchronized so i dont delete my backup by accident, and i need to verify the byte-level difference of the files so i dont re-upload the same files to the backup, so i will try to setup rclone with Proton Drive, i will write a tutorial about it when i get it working.

#### How to install rclone with Proton Drive

Apparently as of this date (10/8/2026) rclone is having problems with the proton backend, since they recently changed the API (released the CLI and SDK for proton in 1/7/2026 so open-source projects should take some time to adapt), so i will wait until they fix it, and then i will write a tutorial about it. But rclone seems like a really good tool to learn.

More here:

https://forum.rclone.org/t/proton-drive-x-rclone/53609

https://www.reddit.com/r/ProtonMail/comments/18s211d/proton_drive_for_linux/

https://rclone.org/

#### Secret solution: Use Windows app :c

Just for now, i will log in to my Proton Drive account using the Windows app, and upload my backup there, since it has synchronization and checksum verification, so i can be sure that my backup is safe.

### Proton Mail

I dont care for now

### Proton Calendar

I will use the web version for now, but i will try to install the CLI when i need to automate stuff.

### Proton Pass


