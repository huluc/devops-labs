#!/usr/bin/env bash
# Build and push the three app images to Docker Hub
set -e

SRC=~/ironhack-project-1
USER=hserindik

for app in vote:voting-app result:result-app worker:worker-app; do
  dir=${app%%:*}     # folder name (vote, result, worker)
  image=${app##*:}   # image name (voting-app, result-app, worker-app)
  docker build -t $USER/$image $SRC/$dir
  docker push $USER/$image
done
