## Set up docker containers for development in LAMP, python, JAVA, etc

### Install Docker Engine on Debian 13

#### Actualizar sistema, repo de apps e instalar dependencia necesaria (curl)

```bash
sudo apt update && sudo apt upgrade -y
```

```bash
sudo apt install curl
```

#### Desinstalar versiones previas de docker

```bash
for pkg in docker-ce docker-ce-cli docker-desktop docker-model-plugin containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get purge -y $pkg; done
```

#### Next, download the official Docker installation script:

```bash
curl -fsSL https://get.docker.com -o get-docker.sh
```

#### After downloading the script, execute it to install Docker Engine

```bash
sudo sh get-docker.sh
```

#### Verify docker version

```bash
docker version
```

#### Test Docker Installation with hello-world Container

```bash
docker run hello-world
```

#### Manage Docker as a Non-Root User

```bash
sudo gpasswd -a pollo docker
```

### Use docker

#### Install docker desktop (just in case is useful)[https://docs.docker.com/desktop/setup/install/linux/debian/]

- Download the .deb package from the official Docker website.

```bash
sudo apt-get update
sudo apt-get install ./docker-desktop-amd64.deb
```

#### Create a Docker container for an angular app

* Clone your desired app repository or create a new directory for your Docker project.

* Create a Dockerfile in the project directory to define your application's environment and dependencies.

* For example, for an angular app it looks something like this:

```Dockerfile
FROM node:22

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

ENV PORT=4200
EXPOSE 4200

CMD ["npm", "start"]
```

* Create a dockerignore file to exclude unnecessary files from the Docker build context.

```
node_modules
dist
.git
```

* Build the Docker image using the Dockerfile. (Run this command in the terminal from the project directory):

```bash
docker build -t my-angular-app .
```

* Run the Docker container from the built image:

```bash
docker run -p 4200:4200 my-angular-app
```

* In case you get the error 'port already in use', restart docker service

```bash
sudo systemctl restart docker
``` 

* In case you get the error 'Connection reset by peer', make sure your app is configured to listen on all network interfaces (0.0.0.0), in Angular, go to package.json and change the start script to:

```json
"start": "ng serve --host 0.0.0.0 --port 4200"
```

* In case you want live development, mount the project folder as a volume in the container and remove COPY . . from the dockerfile, then run:

```bash
docker run -p 4200:4200 -v $PWD:/app -v /app/node_modules my-angular-app
```