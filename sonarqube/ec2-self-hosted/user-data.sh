#!/bin/bash
apt-get update -y
apt-get install -y docker.io
usermod -aG docker ubuntu
