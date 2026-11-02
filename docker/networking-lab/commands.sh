#!/usr/bin/env bash
# Docker networking lab: isolation test with ping
# No "set -e": the first pings are EXPECTED to fail.

docker network create --driver bridge --subnet=192.168.1.0/24 isolatedNetwork
docker run -dit --name container1 --network isolatedNetwork alpine
docker run -dit --name container2 alpine   # default bridge

echo "--- Expected FAIL (name: no DNS across networks)"
docker exec container1 ping -c 3 container2

echo "--- Expected FAIL (IP: traffic blocked between networks)"
C2_IP=$(docker inspect -f '{{.NetworkSettings.Networks.bridge.IPAddress}}' container2)
docker exec container1 ping -c 3 -W 2 $C2_IP

docker network connect isolatedNetwork container2

echo "--- Expected SUCCESS (same network now)"
docker exec container1 ping -c 3 container2

# Cleanup
docker rm -f container1 container2
docker network rm isolatedNetwork
