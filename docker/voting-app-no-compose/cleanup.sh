#!/usr/bin/env bash
# Remove all lab containers and networks
docker rm -f voting-app worker-app result-app redis db
docker network rm frontend backend
