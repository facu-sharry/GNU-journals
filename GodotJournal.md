# Welcome to the Godot Journal!
## Step 1: Installation of Godot Engine
### Downloading Godot
- Visit the official Godot Engine website at https://godotengine.org/download to download the latest stable version of Godot for your operating system.
- Choose the appropriate version for your system (Windows, macOS, Linux) and download the ZIP or TAR file.
### Installing Godot
- For Windows and macOS, simply extract the downloaded file to a desired location.
- For Linux, you can extract the TAR file to a directory of your choice. For example, you can use the terminal:
```bash
tar -xvf godot-<version>-stable-x11.64.tar.xz -C ~/Games/
```
### Running Godot
- Navigate to the directory where you extracted Godot and run the executable file.
- On Linux, you can run it from the terminal:
```bash
~/Games/godot-<version>-stable-x11.64
```
## Step 2: Setting Up a New Project
### Creating a New Project
- Open Godot Engine and click on "New Project".
- Enter a name for your project and choose a location to save it.
- Select a template (2D, 3D, etc.) and click "Create & Edit".
### Configuring Project Settings
- Once your project is created, you can configure various settings by going to "Project" > "Project Settings".
- Here, you can adjust settings such as display resolution, input mappings, and more.
## Step 3: Learning the Basics
### Exploring the Interface
- Familiarize yourself with the Godot interface, including the Scene panel, Inspector, Node system, and Script editor.
### Tutorials and Documentation
- Visit the official Godot documentation at https://docs.godotengine.org/ to access tutorials, guides, and API references.
- Consider following beginner tutorials available on YouTube or other learning platforms to get hands-on experience with Godot.
## Step 4: Creating Your First Game
### Adding Nodes
- Start by adding nodes to your scene. Right-click in the Scene panel and select "Add Child Node" to add various types of nodes (e.g., Sprite, Camera, etc.).
### Scripting
- Use GDScript, Godot's built-in scripting language, to add functionality to your game. You can create a new script by right-clicking on a node and selecting "Attach Script".
### Testing Your Game
- Click the "Play" button at the top of the interface to test your game. Make adjustments as needed based on your testing.
## Conclusion
- Congratulations! You have successfully set up Godot Engine and created your first project. Continue exploring and learning to develop more complex games using Godot. Happy game development!

## Personal Notes
- Remember to frequently save your project and back up your work.
- Experiment with different nodes and scripts to enhance your understanding of Godot's capabilities.
- Join the Godot community forums and Discord channels to connect with other developers and seek help when needed.
- Use git for version control to manage your project files effectively by initializing a git repository in your project folder:
```bash
cd ~/path/to/your/godot/project
git init
```
- Commit your changes regularly:
```bash
git add .
git commit -m "Initial commit"
```

- Explore Godot Asset Library for free assets and plugins to enhance your projects: https://godotengine.org/asset-library/assets
- Keep an eye on Godot's release notes for updates and new features: https://godotengine.org/articles
- Consider learning about Godot's built-in physics engine to create more dynamic gameplay experiences.
- Practice using Godot's animation system to bring your game characters and objects to life.
- Experiment with exporting your game to different platforms using Godot's export templates.
```bash
godot --export "Windows Desktop" ~/Games/MyGame.exe
```
- Stay updated with the latest Godot news and community events by following the official Godot blog: https://godotengine.org/blog
- Join Godot-related social media groups to stay connected with other developers and share your progress.
- Explore advanced topics such as shaders, networking, and multiplayer game development as you become more comfortable with Godot.
- Always test your game on different devices and screen sizes to ensure compatibility and a good user experience.
- Consider contributing to the Godot open-source project if you have programming skills and want to give back to the community.
- Regularly check for updates to Godot Engine and keep your installation up to date to benefit from the latest features and bug fixes.

## Really Personal Notes (NO IA)

* I added a desktop icon for Godot by creating a .desktop file in `~/.local/share/applications/godot.desktop` and in `~/Desktop/godot.desktop` with the following content:

```ini
[Desktop Entry]
Type=Application
Version=1.0
Name=Godot
GenericName=Free Game Engine
NoDisplay=false
Comment=Create Games
Exec=/home/pollo/Games/Godot_v4.5.1-stable_linux.x86_64
Icon=/home/pollo/Games/godot-svgrepo-com.svg
Terminal=false
Categories=Game;GameEngine;
Encoding=UTF-8
Actions=Fullscreen;DefaultConfig;
```

* Naming conventions
For this project, we will be following the Godot naming conventions.

GDScript: Classes (nodes) use PascalCase, variables and functions use snake_case, and constants use ALL_CAPS (See GDScript style guide).

* Directory structure
```bash
MyGodotProject/
├── assets # Media files such as images, audio, etc. (sprites, sounds, music)
│   └── Sprites
│       └── Player
│            ├── player_idle.png
│            ├── player_attack1.png
│            ├── player_run.png
│            └── player_jump.png
├── core # Core systems and utilities for gluing the game together
│   ├── core.gd
├── data # Game data resources (classes) and data files (json, csv, etc.)
│   ├── abilities
│   ├── entities
│   │   ├── EntityResource.gd
│   │   ├── EntityResource.gd.uid
│   │   └── player
│   │       ├── MovementData.tres # Instance of MovementResource.gd
│   ├── items
│   ├── MovementResource.gd # Defines attributes related to movement
│   └── MovementResource.gd.uid
├── entities # Game entities (players, enemies, NPCs, etc.) (handles ONLY input, animation, state)
│   ├── enemies
│   ├── entity.gd
│   ├── entity.gd.uid
│   ├── player
│   │   ├── Player.gd
│   │   ├── Player.gd.uid
│   │   └── player.tscn
│   └── playground.tscn
├── icon.svg
├── icon.svg.import
├── LICENSE
├── project.godot
└── systems # Game systems (combat, inventory, movement, etc.) (should be playable independently)
    ├── combat
    ├── inventory
    └── movement
        ├── movement_system.gd # Handles movement logic for entities
        └── movement_system.gd.uid

```