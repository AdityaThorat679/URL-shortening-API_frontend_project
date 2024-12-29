# URL-Shortening-api
## Tools & Technology Used:
- Git
- GitHub
- Docker
- Jenkins
- Kubernetes (Minikube)
- Ingress-Nginx Controller

## For Creating similar Architecture follow the below steps
### Below are the article/document Links to install the required tools
- [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
- [Docker](https://docs.docker.com/engine/install/)
- [Jenkins](https://www.jenkins.io/doc/book/installing/)
- [Minikube](https://minikube.sigs.k8s.io/docs/start/?arch=%2Fwindows%2Fx86-64%2Fstable%2F.exe+download)
- [Ingress-Nginx Controller](https://kubernetes.github.io/ingress-nginx/deploy/)
  

### Steps and Setup the project
- **Clone the repo**
```bash
git clone https://github.com/AdityaThorat679/URL-shortening-API_frontend_project.git
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
docker build -t url-shortening-api .
```
This command builds a Docker image named url-shortening-api with the tag latest using the Dockerfile found in the current directory.

- **Run Image / Run Container**
 ```bash
docker run -d -p 80:80 url-shortening-api
```
Here's a simplified explanation of the command `docker run -p 80:80 huddle-landing-page:latest`:
1. **docker run**: Starts a new Docker container.
2. **-p 80:80**: Maps port 80 on the host to port 80 on the container, allowing access to the web server running inside the container.
3. **huddle-landing-page:latest**: Specifies the Docker image (`url-shortening-api` with the `latest` tag) to use for creating the container.

When executed, this command runs the `url-shortening-api` Docker image, mapping port 80 on your host machine to port 80 on the container, so you can access the application via `http://localhost:80` on your host.-app: Specifies the Docker image (nodejs-app with tag latest) to use for creating the container.

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
                git url:"https://github.com/AdityaThorat679/URL-shortening-API_frontend_project.git", branch: "main"
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

## Deployment Using Kubernetes and Minikube
**Deploying a Project Using Kubernetes with Minikube**  

Minikube is a tool that lets you run Kubernetes on your local machine. It’s great for testing and learning how Kubernetes works. When you deploy a project using Minikube, you:  

1. Start a Kubernetes cluster using Minikube.  
2. Create YAML files to define how your app should run (like the app’s container, number of replicas, and how it connects to the network).  
3. Apply these YAML files to the Minikube cluster to deploy your app.  

This process helps you see how your app would work in a real Kubernetes environment, all from your own computer. It’s simple, quick, and perfect for practice!  

## Deployment.yaml
```bash
# This is a sample deployment manifest file for a simple web application.
apiVersion: apps/v1
kind: Deployment
metadata:
  name: url
  labels:
    app: url
spec:
  replicas: 1
  selector:
    matchLabels:
      app: url
  template:
    metadata:
      labels:
        app: url
    spec:
      containers:
      - name: url
        image: adityathorat679/url_short
        ports:
        - containerPort: 80
```

```bash
kubectl apply -f deployment.yaml
```
Here’s a breakdown of the **Kubernetes Deployment file**:

### **File Sections Explained:**

#### 1. **`apiVersion`**
- Specifies the API version used for the deployment.
- In this file: `apps/v1` is the version used for managing Deployments in Kubernetes.

#### 2. **`kind`**
- Defines the type of Kubernetes resource.
- Here: `Deployment` is the resource type, used to manage and scale application instances.

#### 3. **`metadata`**
- Provides metadata about the resource.
- `name`: The unique name of the Deployment (`url` in this case).
- `labels`: Key-value pairs used to categorize the Deployment (e.g., `app: url`).

#### 4. **`spec`**
- Defines the desired state of the Deployment.

##### **a. `replicas`**
- Specifies the number of instances (pods) to run.
- Here: `1` pod is created.

##### **b. `selector`**
- Tells Kubernetes how to identify the pods managed by this Deployment.
- `matchLabels`: Matches pods with the label `app: url`.

##### **c. `template`**
- Defines the pod configuration, including its metadata and spec.

###### **i. `metadata`**
- Labels for the pod. Pods created will have `app: url` as their label.

###### **ii. `spec`**
- Describes the containers in the pod.

#### 5. **`containers`**
- Specifies the container(s) to run within the pod.

##### **a. `name`**
- A unique name for the container (`url` in this case).

##### **b. `image`**
- The Docker image to use for the container (`adityathorat679/url_short` is the user’s Docker Hub image).

##### **c. `ports`**
- Declares which port the container exposes.
- `containerPort: 80` means the app inside the container listens on port `80`.

---

### **Summary**
This file tells Kubernetes to:
1. Create a Deployment named `url`.
2. Run one replica (pod) containing a container.
3. Use the Docker image `adityathorat679/url_short`.
4. Expose port `80` inside the container for communication. 

## Ingress.yaml
```bash
# Ingress resource for the application
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: url
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  ingressClassName: nginx
  rules:
  - host: url.local
    http:
      paths: 
      - path: /
        pathType: Prefix
        backend:
          service:
            name: url
            port:
              number: 8000
```

```bash
kubectl apply -f ingress.yaml
```
Here’s an explanation of the **Ingress resource** manifest:

### **What is an Ingress Resource?**
Ingress is a Kubernetes resource that manages external access to services within a cluster, typically HTTP/HTTPS traffic. It provides routing rules to direct requests to the appropriate services.

---

### **Explanation of the Ingress Manifest**

#### 1. **`apiVersion`**
- Specifies the API version for the Ingress resource.  
- `networking.k8s.io/v1` is used for modern Kubernetes Ingress configurations.

#### 2. **`kind`**
- Defines the type of resource.  
- Here: `Ingress` manages HTTP and HTTPS routing for your application.

#### 3. **`metadata`**
- Metadata information about the Ingress resource.  
  - `name`: The name of the Ingress resource (`url`).  
  - `annotations`: Key-value pairs for additional configurations.
    - `nginx.ingress.kubernetes.io/rewrite-target: /` ensures that the request path is rewritten to the root (/) when passed to the backend.

#### 4. **`spec`**
- Describes the desired configuration for the Ingress resource.

##### **a. `ingressClassName`**
- Specifies the Ingress controller to be used.  
- `nginx` means this configuration is for an NGINX Ingress Controller.

##### **b. `rules`**
- Defines routing rules for the application.

###### **i. `host`**
- The domain name used to access the application (`url.local` in this case).  
- You can test it locally by adding `url.local` to your system’s `/etc/hosts` file pointing to the Minikube IP.

###### **ii. `http`**
- Configures the HTTP routing.

###### **iii. `paths`**
- Describes how HTTP requests should be routed.

1. **`path`**:  
   - `/` matches all requests to the root path of the domain.  
   - `pathType: Prefix` ensures any URL starting with `/` is routed.

2. **`backend`**:
   - The target service and port for this path.  
   - `service.name: url`: Directs traffic to the `url` service.  
   - `service.port.number: 8000`: Routes traffic to port `8000` of the service.

---

### **Summary**
This Ingress resource:
1. Routes traffic from `url.local` to the `url` service.
2. Redirects requests starting with `/` to port `8000` of the service.
3. Uses an NGINX Ingress Controller to handle these rules.
4. Ensures the URL path is rewritten to `/` before sending it to the backend service.

## Service.yaml
```bash
# Service for the application
apiVersion: v1
kind: Service
metadata:
  name: url
  labels:
    app: url
spec:
  ports:
  - port: 8000
    targetPort: 80
    protocol: TCP
  selector:
    app: url
  type: NodePort



# apiVersion: v1
# kind: Service
# metadata:
#   name: go-web-app
# spec:
#   type: NodePort
#   selector:
#     app: go-web-app
#   ports:
#     - port: 80
#       targetPort: 8000
#       nodePort: 30000
```

```bash
kubectl apply -f service.yaml
```

1. **`apiVersion`**  
   - Defines the API version.  
   - `v1` is used for Kubernetes Service resources.

2. **`kind`**  
   - Specifies the resource type.  
   - `Service` exposes the application to allow communication between different components or external access.

3. **`metadata`**  
   - **`name`**: The name of the Service is `url`.  
   - **`labels`**: Identifies the Service with a label (`app: url`).

4. **`spec`**  
   - Describes the configuration of the Service.

   - **`ports`**:
     - **`port`**: The port on the Service that external applications use to communicate (`8000`).  
     - **`targetPort`**: The port on the container that the Service forwards traffic to (`80`).  
     - **`protocol`**: Protocol for communication (`TCP`).  

   - **`selector`**:
     - Matches pods with the label `app: url` to connect them to the Service.  

   - **`type`**:  
     - **`NodePort`** exposes the Service on a randomly assigned port between 30000-32767, making it accessible externally via the cluster node's IP.

#### How to Check if All Kubernetes Files Were Applied Successfully

To check if all Kubernetes resources (files) were applied successfully, you can use the following commands to verify the status of your resources:

### **1. Check All Resources in the Cluster:**
```bash
kubectl get all
```
This command lists all resources (pods, services, deployments, etc.) in the current namespace.

### **2. Check the Status of Specific Resources (e.g., Pods, Deployments, Services):**
- **Check Pods:**
  ```bash
  kubectl get pods
  ```
  This shows the status of all pods in the current namespace (e.g., Running, Pending, or Failed).

- **Check Deployments:**
  ```bash
  kubectl get deployments
  ```
  This shows the status of all deployments and whether they are successfully created and running.

- **Check Services:**
  ```bash
  kubectl get services
  ```
  This shows the status of services in the cluster.

### **3. Describe Resources for Detailed Information:**
- **Describe Pod:**
  ```bash
  kubectl describe pod <pod_name>
  ```
  This provides detailed information about the specific pod, including events and logs.

- **Describe Deployment:**
  ```bash
  kubectl describe deployment <deployment_name>
  ```
  This gives detailed information about a deployment's status.

### **4. Check Logs for Any Errors:**
To view logs of a specific pod and check for any errors after applying the file:
```bash
kubectl logs <pod_name>
```

### **5. Verify Resource Health (e.g., for Deployments or Pods):**
Check if the deployment or pod is successfully running the expected number of replicas:
```bash
kubectl get deployment <deployment_name>
```
or
```bash
kubectl get pods
```
## **Ingress Controller** in Minikube.  

### **Why Use It?**
- It allows you to manage external HTTP/HTTPS traffic to your applications using **Ingress resources**.  
- Once enabled, you can define rules to route traffic based on domains or paths.

### **Simple Example**  
1. Run the command:  
   ```bash
   minikube addons enable ingress
   ```
2. Verify it's running:  
   ```bash
   kubectl get pods -n kube-system
   ```
3. Create an **Ingress resource** to route traffic to your service.  

## DNS mapping
### Step 1: Get ingress address
```bash
kubectl get ing
```
### Step 2: Open hosts file 
```bash
sudo vim /etc/hosts
```
The `/etc/hosts` file maps **hostnames** (like `my-app.local`) to **IP addresses** (like `127.0.0.1`). It helps your computer find services or websites by name without using DNS. You can edit it to add custom names for local development or override DNS settings.

### Step 3: DNS Mapping 
```bash
<Address> host name
```
Add a new line with the **Ingress IP address** from step 2 and the **hostname** from your `ingress.yaml` file.

Open your browser and check your hostname
