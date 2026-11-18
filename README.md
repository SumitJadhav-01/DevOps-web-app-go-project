# DevOps Web Application – Go

A Go-based web application deployed on **AWS EKS** using Docker, Kubernetes, Helm, GitHub Actions, and Argo CD. This project demonstrates an end-to-end DevOps workflow, from source-code validation and container image publishing to GitOps-based Kubernetes deployment

## 📚 End-to-End Project Documentation

For the complete step-by-step implementation, configuration, deployment, verification, and troubleshooting details, see the full project documentation:

📄 **[View End-to-End Documentation](./End_to_End_Documentation.docx)**

> The documentation covers the complete implementation of this DevOps project from application setup to deployment, monitoring, verification, and troubleshooting.

## Project Overview

The application is developed using Go and exposes three pages:

- `/home`
- `/contact`
- `/about`

The project demonstrates how to automate application build, testing, code-quality checks, Docker image publishing, Helm chart updates, and deployment to Amazon EKS.

## Architecture

```text
             Developer
                 |
                 v
             GitHub
                 |
                 v
          GitHub Actions
                 |
        +--------+---------+
        |        |         |
      Build    Test    Code Quality
        |        |         |
        +--------+---------+
                 |
                 v
          Docker Build
                 |
                 v
       Push Image to Docker Hub
                 |
                 v
       Update Helm Image Tag
                 |
                 v
          Git Repository
                 |
                 v
              Argo CD
                 |
                 v
             AWS EKS
                 |
        +--------+---------+
        |        |         |
      Pods    Service   Ingress
                 |
                 v
          Go Web Application

Monitoring (implementation in progress):
Prometheus + Grafana
```

## Technologies Used

| Category | Tools |
|---|---|
| Application | Go |
| Version Control | Git, GitHub |
| CI/CD | GitHub Actions |
| Containerization | Docker |
| Container Registry | Docker Hub |
| Cloud Platform | AWS |
| Kubernetes | Amazon EKS |
| Infrastructure Provisioning | eksctl / AWS |
| Package Management | Helm |
| GitOps | Argo CD |
| Networking | Kubernetes Services, NGINX Ingress |
| Monitoring | Prometheus and Grafana (in progress) |
| Operating System | Linux / Ubuntu |

## CI Pipeline – GitHub Actions

The CI pipeline is defined in:

`.github/workflows/ci.yaml`

The pipeline automates the following stages:

### 1. Build and Test

- Checks out the source code.
- Sets up the Go environment using the project's Go configuration.
- Downloads Go dependencies.
- Builds the application.
- Executes Go tests.

### 2. Code Quality

- Checks Go formatting using `gofmt`.
- Runs static analysis using `go vet`.
- Runs linting using golangci-lint.

### 3. Docker Build and Push

- Builds the Docker image.
- Authenticates with Docker Hub using GitHub repository secrets.
- Pushes the image to Docker Hub.
- Uses the short Git commit SHA as the image tag.

Docker Hub repository:

https://hub.docker.com/r/sumitjadhav652/webappgo

### 4. Update Helm Image Tag

- Updates the image tag in `helm/webappgo/values.yaml`.
- Commits and pushes the updated Helm configuration to GitHub.
- Prevents an unnecessary workflow loop by excluding the Helm values file from the push trigger.

## Kubernetes Deployment – AWS EKS

The application is deployed on Amazon Elastic Kubernetes Service (EKS).

Kubernetes resources used:

- **Deployment:** Manages application Pods and replicas.
- **Pods:** Run the Go application containers.
- **Service:** Exposes the application internally using ClusterIP.
- **Ingress:** Routes external HTTP traffic to the application through NGINX Ingress Controller.

Application container port: `8080`

## Helm

Helm is used to package and manage Kubernetes deployment configuration.

Chart location:

`helm/webappgo/`

Main chart files:

```text
helm/webappgo/
├── Chart.yaml
├── values.yaml
└── templates/
    ├── deployment.yaml
    ├── service.yaml
    └── ingress.yaml
```

The Docker image repository and tag are configured in `values.yaml`. GitHub Actions updates the image tag whenever a new image is published.

## Argo CD – GitOps Deployment

Argo CD is used to implement GitOps-based continuous delivery.

The workflow is:

1. GitHub Actions builds and pushes a new Docker image.
2. GitHub Actions updates the image tag in the Helm chart.
3. Argo CD monitors the Git repository.
4. Argo CD detects the updated Helm configuration.
5. Argo CD synchronizes the changes with the EKS cluster.
6. Kubernetes deploys the updated application.

The Argo CD application is configured with automatic synchronization and self-healing.

## Monitoring – Prometheus and Grafana

**Implementation in progress**

The planned monitoring stack uses the Prometheus Community `kube-prometheus-stack` Helm chart.

Planned components:

- **Prometheus:** Collects metrics.
- **Grafana:** Visualizes metrics through dashboards.
- **Alertmanager:** Handles alert notifications.
- **Node Exporter:** Collects node-level metrics.
- **Kube State Metrics:** Provides Kubernetes resource-state metrics.

The monitoring installation and persistent storage configuration must be verified before considering this section complete.

## Run the Application Locally

### Prerequisites

- Go installed
- Git installed

### Clone the repository

```bash
git clone https://github.com/SumitJadhav-01/DevOps-web-app-go-project.git
cd DevOps-web-app-go-project
```

### Download dependencies

```bash
go mod download
```

### Build and test

```bash
go build ./...
go test ./...
```

### Run the application

```bash
go run .
```

Open the application at:

`http://localhost:8080/home`

## Run with Docker

### Build the image

```bash
docker build -t webappgo .
```

### Run the container

```bash
docker run -d -p 8080:8080 --name webappgo webappgo
```

Open:

`http://localhost:8080/home`

## Project Structure

```text
DevOps-web-app-go-project/
├── .github/
│   └── workflows/
│       └── ci.yaml
├── helm/
│   └── webappgo/
│       ├── Chart.yaml
│       ├── values.yaml
│       └── templates/
├── k8s/
│   └── manifests/
├── Dockerfile
├── go.mod
├── main.go
└── README.md
```

Additional source files, tests, and documentation may also be present in the repository.

## Key Learning Outcomes

- Implementing CI pipelines using GitHub Actions.
- Building and testing Go applications.
- Automating code-quality checks.
- Building and publishing Docker images.
- Deploying containerized applications on Amazon EKS.
- Managing Kubernetes resources using Helm.
- Implementing GitOps deployment using Argo CD.
- Understanding Kubernetes Services and Ingress networking.
- Working with AWS cloud infrastructure.

## Author

**Sumit Jadhav**

- **Portfolio:** https://sumitjadhav.lovable.app
- **GitHub:** https://github.com/SumitJadhav-01
- **LinkedIn:** https://www.linkedin.com/in/sumitjadhav-
- **Email:** sumitjadhav3993@gmail.com
