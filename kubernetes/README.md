# Kubernetes Labs

All labs run on a local **Minikube** cluster.

| Lab | Focus |
|---|---|
| [pod-lab](pod-lab) | Single Pods: NGINX, BusyBox commands, `restartPolicy`, environment variables |
| [deployment-lab](deployment-lab) | Deployment with 3 replicas and a ConfigMap (`envFrom`) |
| [service-lab](service-lab) | NodePort Service in front of an NGINX Deployment |
| [redis](redis) | Redis Deployment with a NodePort Service |
| [java-app](java-app) | Java app → Docker image → Docker Hub → Kubernetes |
| [guestbook](guestbook) | Multi-tier app: PHP frontend, Redis leader and followers |