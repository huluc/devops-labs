#!/usr/bin/env bash
# Create networks and start all 5 containers (no Docker Compose)
set -e

USER=hserindik

# Networks (skip if they already exist)
docker network inspect frontend >/dev/null 2>&1 || docker network create frontend
docker network inspect backend  >/dev/null 2>&1 || docker network create backend

# Databases first
docker run -d --name redis --network frontend redis:latest
docker run -d --name db --network backend \
  -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres postgres:latest

# Apps
docker run -d --name voting-app --network frontend -p 5000:80 $USER/voting-app
docker run -d --name worker-app --network frontend --network backend $USER/worker-app
docker run -d --name result-app --network backend -p 5001:80 $USER/result-app

docker ps
