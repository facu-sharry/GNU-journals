# Set up docker containers for development in LAMP, python, JAVA, etc

## Install Docker Engine on Debian 13

### Actualizar sistema, repo de apps e instalar dependencia necesaria (curl)

```bash
sudo apt update && sudo apt upgrade -y
```

```bash
sudo apt install curl
```

### Desinstalar versiones previas de docker

```bash
for pkg in docker-ce docker-ce-cli docker-desktop docker-model-plugin containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get purge -y $pkg; done
```

### Next, download the official Docker installation script:

```bash
curl -fsSL https://get.docker.com -o get-docker.sh
```

### After downloading the script, execute it to install Docker Engine

```bash
sudo sh get-docker.sh
```

### Verify docker version

```bash
docker version
```

### Manage Docker as a Non-Root User by adding your user to the docker group.

```bash
sudo gpasswd -a pollo docker
```

-  Why use a Non-Root User for Docker?
> Running Docker as a non-root user enhances security by limiting the potential impact of vulnerabilities. It prevents unauthorized access to the Docker daemon and reduces the risk of privilege escalation attacks. By using a non-root user, you can safely manage containers without exposing the system to unnecessary risks, ensuring a more secure and controlled environment for containerized applications.

- Create a new user (if you don't want to use your current user):

```bash
sudo adduser docker-admin
```

- Add the new user to the docker group:

```bash
sudo usermod -aG docker docker-admin
```

- Verify that the user has been added to the docker group:

```bash
groups docker-admin
```

- Verify that the user can run Docker commands without sudo:

```bash
su - docker-admin
docker ps
```

### Recommended Directory structure for docker projects

```bash
# Crear estructura de directorios
sudo mkdir -p /opt/docker/{mariadb,bookstack}
sudo chown docker_admin:docker_admin /opt/docker -R
sudo chmod 750 /opt/docker -R

# Directorios dentro
/opt/docker/
├── mariadb/
│   ├── docker-compose.yml
│   ├── data/
│   └── init-scripts/
└── bookstack/
    ├── docker-compose.yml
    └── config/

```

## Use docker

#### Docker cheatsheet
``
https://docs.docker.com/get-started/docker_cheatsheet.pdf
``

#### Test Docker Installation with hello-world Container

```bash
docker run hello-world
```

### Concepts

#### 1 DockerFile
> A DockerFile is the recipe for creating a docker image. Its used to define *your application's* OS/enviroment, dependencies, files to copy into the image, what commands to run when the container starts, env variables, ports and other settings . It will and can use other sources like 'node', 'ubuntu', etc and you will write things like when and where you want to run npm run build, etc.

* Core Dockerfile Syntax

| Instruction 	| Purpose 												| Example |
| ------------	|---------												|---------|
| FROM			| Base image to build on (required, must be first)		| FROM ubuntu:22.04 or FROM alpine:3.18
| RUN			| Execute commands during build (creates a layer)		| RUN apt-get update && apt-get install -y apache2
| COPY			| Copy files from host to image							| COPY app.conf /etc/apache2/sites-available/
| ADD			| Like COPY but can extract tar files and fetch URLs	| ADD app.tar.gz /app/
| WORKDIR		| Set working directory inside container				| WORKDIR /var/www/html
| ENV			| Set environment variables (baked into image)			| ENV APP_ENV=production
| EXPOSE		| Document which ports the app listens on				| EXPOSE 80 443
| CMD			| Default command to run when container starts			| CMD ["apache2ctl", "-D", "FOREGROUND"]
| ENTRYPOINT	| Alternative to CMD; harder to override				| ENTRYPOINT ["python", "app.py"]

* Basic Dockerfile example:

```Dockerfile
# Start from official Ubuntu with Apache pre-installed
FROM ubuntu:22.04

# Update package manager and install Apache
RUN apt-get update && apt-get install -y \
    apache2 \
    apache2-utils \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /var/www/html

# Copy your app files into the image
COPY ./myapp/ /var/www/html/

# Copy custom Apache config
COPY ./apache.conf /etc/apache2/sites-available/000-default.conf

# Enable Apache modules
RUN a2enmod rewrite

# Set environment variable
ENV APP_ENV=production

# Expose port 80
EXPOSE 80

# Start Apache in foreground (important for Docker)
CMD ["apache2ctl", "-D", "FOREGROUND"]

```

* Efficient Dockerfile Practices

1. Layer Caching — Order Matters

Dockerfile creates a layer for each instruction. Docker caches layers; if nothing changed, it reuses the cache.

Inefficient:

```dockerfile

FROM ubuntu:22.04
COPY ./myapp/ /var/www/html/
RUN apt-get update && apt-get install -y apache2

# Problem: If you change one file in myapp/, the COPY layer rebuilds and invalidates the RUN cache, forcing a full reinstall.
```

Efficient:

```dockerfile

FROM ubuntu:22.04
RUN apt-get update && apt-get install -y apache2
COPY ./myapp/ /var/www/html/

# Benefit: Dependencies install once. Code changes only rebuild the COPY layer.
```

2. Minimize Image Size

```dockerfile

# Bad: Creates bloated images
FROM ubuntu:22.04
RUN apt-get update && apt-get install -y apache2
RUN apt-get install -y curl
RUN apt-get install -y git

# Good: Combine RUN commands, clean up package cache
FROM alpine:3.18  # Much smaller base image
RUN apk add --no-cache apache2 curl git

# Or on Ubuntu:
RUN apt-get update && apt-get install -y \
    apache2 \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*
```

Why? Each RUN creates a layer. Combining them reduces layers and size. rm -rf /var/lib/apt/lists/* removes cached package data.

3. Use Multi-Stage Builds (For Compiled Apps)

```dockerfile

# Stage 1: Build
FROM golang:1.21 AS builder
WORKDIR /app
COPY . .
RUN go build -o myapp .

# Stage 2: Runtime (much smaller)
FROM alpine:3.18
COPY --from=builder /app/myapp /usr/local/bin/
EXPOSE 8080
CMD ["myapp"]
```

Benefit: Final image contains only the compiled binary, not the entire Go toolchain.

4. Use .dockerignore

```dockerfile
# .dockerignore file (like .gitignore)
.git
.env
node_modules
__pycache__
*.log
```

Prevents unnecessary files from being copied, reducing build time and image size.

5. Avoid Running as Root

```dockerfile

FROM ubuntu:22.04
RUN apt-get update && apt-get install -y apache2

# Create non-root user
RUN useradd -m -s /bin/bash appuser
USER appuser

CMD ["apache2ctl", "-D", "FOREGROUND"]
```

(Note: Apache specifically often needs root for port 80, but principle applies elsewhere.)

#### 2. Docker Image

> Docker images are a lightweight, standalone, executable package of software that includes everything needed to run an application: code, runtime, system tools, system libraries and settings. Think of them like a frozen snapshot or a class definition in programming.

- ex:
```
/usr/bin/nslookup
/var/cache
mkdir -> /bin/execs
gzip -> /bin/execs
...
...
...
``` 

#### 3rd Docker Containers
> A container is a runtime instance of a docker image. A container will always run the same, regardless of the infrastructure. Containers isolate software from its environment and ensure that it works uniformly despite differences for instance between development and staging.

#### 4. Docker Volumes
> Docker volumes are a way to persist data generated by and used by Docker containers. Volumes are stored outside the container's filesystem, on the host machine, and can be shared between containers.

#### 5. Docker Networks
> Docker networks allow containers to communicate with each other and with the host system. By default, Docker creates a bridge network for containers, but you can create custom networks to control how containers interact.

#### 6. Docker Compose
> Docker Compose is a tool for defining and running multi-container Docker applications. With Compose, you use a YAML file to configure your application's services, networks, and volumes, and then you can start all the services with a single command.

#### 7. Docker Swarm
> Docker Swarm is Docker's native clustering and orchestration tool. It allows you to manage a cluster of Docker nodes as a single virtual system, enabling you to deploy and scale applications across multiple hosts. Swarm mode provides features like service discovery, load balancing, rolling updates and secret management.

#### 8. Docker Secrets
> Docker Secrets is a feature that allows you to securely manage sensitive data, such as passwords, API keys, and certificates, within Docker Swarm. Secrets are encrypted and only accessible to services that need them, ensuring that sensitive information is not exposed in the container's environment or filesystem.

### More about using Docker

#### Images commands:
> After writing down the DockerFile
```bash
docker build -t <image_name> .
```
- List local images
```bash
docker images
```
- Delete an Image
```bash
docker rmi <image_name>
```

- Remove all unused images
```bash
docker image prune
```

#### Containers commands:

- Create and run a container (used when building a container for the first time, do not use for starting the container only since it will try to create it again)
```bash
docker run --name <container_name> <image_name>

# Run a container with and publish a container’s port(s) to the host.
docker run -p <host_port>:<container_port> <image_name>

#Run a container in the background
docker run -d <image_name>
```

- Start or stop an existing container: (used after the container was created for the first time and maybe stopped for some reason)
```bash
docker start|stop <container_name> (or <container-id>)
```

- Remove a stopped container:
```bash
docker rm <container_name>
```
- Open a shell inside a running container:
```bash
docker exec -it <container_name> sh
```

- Fetch and follow the logs of a container:
```bash
docker logs -f <container_name>
```

- To inspect a running container:
```bash
docker inspect <container_name> (or <container_id>)
```

- To list currently running containers:
```bash
docker ps
```

- List all docker containers (running and stopped):
```bash
docker ps --all
```

- View resource usage stats
```bash
docker container stats
```

#### Compose commands:
- Start all services defined in the docker-compose.yml file:
```bash
docker compose up
```

- Stop all services:
```bash
docker compose down
```

- Start a specific service:
```bash
docker compose up <service_name>
```

- Stop a specific service:
```bash
docker compose stop <service_name>
```

#### Secrets commands:
- Secrets are only available in Docker Swarm mode. To enable Swarm mode, run:
```bash
docker swarm init
```

- Create a secret:
```bash
echo "my_secret_value" | docker secret create my_secret_name -
```

- List secrets:
```bash
docker secret ls
```

- Remove a secret:
```bash
docker secret rm my_secret_name
```

- Use a secret in a service (in docker-compose.yml):
```yaml
services:
  my_service:
    image: my_image
    secrets:
      - my_secret_name
secrets:
  my_secret_name:
    external: true
```
- /run/secrets/my_secret_name will be available inside the container.


### Install docker desktop (just in case is useful)[https://docs.docker.com/desktop/setup/install/linux/debian/]

- Download the .deb package from the official Docker website.

```bash
sudo apt-get update
sudo apt-get install ./docker-desktop-amd64.deb
```

### DOCKER HUB:
>Docker Hub is a service provided by Docker for finding and sharing
container images with your team. Learn more and find images
at https://hub.docker.com

### Extra info from docker:

```
================================================================================

To run Docker as a non-privileged user, consider setting up the
Docker daemon in rootless mode for your user:

    dockerd-rootless-setuptool.sh install

Visit https://docs.docker.com/go/rootless/ to learn about rootless mode.


To run the Docker daemon as a fully privileged service, but granting non-root
users access, refer to https://docs.docker.com/go/daemon-access/

WARNING: Access to the remote API on a privileged Docker daemon is equivalent
         to root access on the host. Refer to the 'Docker daemon attack surface'
         documentation for details: https://docs.docker.com/go/attack-surface/


```

### Angular App example

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