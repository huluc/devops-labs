# DevOps Labs

Hands-on labs from my DevOps & Cloud Computing bootcamp at Ironhack,
organized by technology. Each lab has its own README with what I did,
what I learned, and screenshots.

## AWS

| Lab | Technologies | What it shows |
|---|---|---|
| [CloudFormation: EC2 with Security Group](aws/cloudformation-ec2-with-sg) | CloudFormation, EC2, IaC | Template with parameters, two linked resources (`!GetAtt`) and outputs |

## Kubernetes

| Lab | Technologies | What it shows |
|---|---|---|
| [Pods](kubernetes/pod-lab) | Kubernetes, BusyBox, NGINX | Pod basics: commands, restart policy, environment variables |
| [Deployment + ConfigMap](kubernetes/deployment-lab) | Kubernetes | Deployment with 3 replicas, configuration injected from a ConfigMap |
| [Service](kubernetes/service-lab) | Kubernetes | Exposing a Deployment with a NodePort Service |
| [Redis](kubernetes/redis) | Kubernetes, Redis | Running a stateful service with a Deployment and Service |
| [Java App](kubernetes/java-app) | Java, Docker, Docker Hub, Kubernetes | Multi-stage Docker build, push to Docker Hub, deploy to Minikube |
| [Multi-Tier Guestbook](kubernetes/guestbook) | Kubernetes, PHP, Redis | Frontend + Redis leader/followers, scaling, labels and selectors |

## Environment

- AWS (shared bootcamp account)
- Minikube on WSL2 (Ubuntu)