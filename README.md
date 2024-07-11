# Huddle-landing-page_frontend_project
## Tools & Technology Used:
- Git
- GitHub
- Docker
- Jenkins

## For Creating similar Architecture follow the below steps
### Below are the article/document Links to install the required tools
- [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
- [Docker](https://docs.docker.com/engine/install/)
- [Jenkins](https://www.jenkins.io/doc/book/installing/)


### Steps and Setup the project
- **Clone the repo**
```bash
git clone https://github.com/AdityaThorat679/Huddle-landing-page_frontend_project.git
```
Here, we are cloning our repo into our local system to check if the code is running and to add the Dockerfile to it.

- **Dockerfile creation**
```bash
FROM httpd
COPY . /usr/local/apache2/htdocs
CMD ["apachectl", "-D", "FOREGROUND"]
```
1. **FROM httpd**:
   - Uses the official Apache HTTP Server image as the base image.

2. **COPY . /usr/local/apache2/htdocs**:
   - Copies all files from the current directory on your host machine to the web root directory (`/usr/local/apache2/htdocs`) inside the container.

3. **CMD ["apachectl", "-D", "FOREGROUND"]**:
   - Sets the command to run when the container starts, keeping the Apache HTTP Server running in the foreground.

- **Build Image**
```bash
docker build -t huddle-landing-page .
```
This command builds a Docker image named huddle-landing-page with the tag latest using the Dockerfile found in the current directory.

- **Run Image / Run Container**
 ```bash
docker run -p 80:80 huddle-landing-page:leatest
```
Here's a simplified explanation of the command `docker run -p 80:80 huddle-landing-page:latest`:
1. **docker run**: Starts a new Docker container.
2. **-p 80:80**: Maps port 80 on the host to port 80 on the container, allowing access to the web server running inside the container.
3. **huddle-landing-page:latest**: Specifies the Docker image (`huddle-landing-page` with the `latest` tag) to use for creating the container.

When executed, this command runs the `huddle-landing-page` Docker image, mapping port 80 on your host machine to port 80 on the container, so you can access the application via `http://localhost:80` on your host.-app: Specifies the Docker image (nodejs-app with tag latest) to use for creating the container.

- **Docker Compose File**
 ```bash
version: '3'
services:
  web:
    build: .
    ports:
      - "80:80"
```
- **version: '3'**: Specifies the version of Docker Compose file format being used (version 3 in this case).
- **services**: Defines the services that make up your application.
  - **web**: Defines a service named `web`.
    - **build: .**: Specifies that the service should be built using the Dockerfile (`Dockerfile`) located in the current directory (`.`).
     - **ports**: Specifies port mappings between the Docker container and the host machine.
       - `"80:80"`: Maps port 80 on the host to port 80 on the container. This allows you to access the application running inside the container via port 80 on your host machine.

 - **Check Docker Compose File is Working Or Not**
```bash
docker compose up
docker compose down
```
**docker compose up**: Starts the application defined in the `docker-compose.yml` file.
**docker compose down**: Stops and removes the containers defined in the `docker-compose.yml` file.

- **To Commit the changes**
```bash
git add .
```
Add all file in staged form 
```bash
git commit -m "Commit with Dockerfile and Docker-Compose.yml file"
```
Commit all changes 

- **Push Code in your GitHub Repo**
```bash
git push
```
GitHub Repo get update 

## Jenkins pipeline ##
### Setup the pipeline ###
- **Open Jenkins**  : Go to your browser and search for `localhost:8080`. This is the default port to open Jenkins.

- **Crate New Pipeline**  : Click on New item -> Enter the item name -> select the Pipeline

- **Set Up Pipeline**
  - Step 1: Click on "GitHub Project" and add your project (repo) URL.
  - Step 2: In "Build Triggers" click on "GitHub hook trigger for GITScm polling."
  - Step 3: In "Pipeline" Definition is "Pipeline Script"
  - Step 4: Write the Script
```bash
pipeline {
    agent any
    
    stages{
        stage("Code"){
            steps {
                echo "Clone the code"
                git url:"https://github.com/AdityaThorat679/Huddle-landing-page_frontend_project.git/", branch: "main"
            }
        }
        stage("Bulid"){
            steps {
                echo "Bulid the image"
                sh "docker build -t url-shortening-api ."
            }
        }
        stage("Deploy"){
            steps {
                echo "Run the docker container"
                sh "docker compose down && docker compose up -d"
            }
        }
    }
}
```
  - Step 5: Click on Save and Click on Build Now
