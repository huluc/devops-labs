# Node.js App – Dockerized

Ironhack DevOps bootcamp lab: containerize a Node.js app (static site served by lite-server) with a Dockerfile.

Source code: [ironhack-labs/nodejsSampleApplication](https://github.com/ironhack-labs/nodejsSampleApplication)

## How to run

```bash
git clone https://github.com/ironhack-labs/nodejsSampleApplication.git
cp Dockerfile .dockerignore nodejsSampleApplication/
cd nodejsSampleApplication
docker build -t sample-node-app .
docker run -d --name node-app -p 3000:3000 sample-node-app
# open http://localhost:3000
docker rm -f -v node-app   # -v also removes the anonymous volume
```

## Changes compared to the lab instructions

- `node:24-slim` instead of `node:latest` (pinned LTS version, smaller image).
- `-p 3000:3000` instead of `80:3000` (port 80 was used by Apache on my machine).
- Added `.dockerignore` (`node_modules`, `.git`).

## What I learned

- **ENTRYPOINT vs CMD:** ENTRYPOINT is the program, CMD its default arguments. Arguments after the image name in `docker run` replace CMD, not ENTRYPOINT.
- **Build context:** the `.` in `docker build` is the folder Docker reads the Dockerfile from and copies files from.
- **`EXPOSE` only documents the port;** the app decides the port, `-p` publishes it. lite-server's UI on port 3001 was not reachable because it wasn't published.
- **`VOLUME` creates an anonymous volume** under `/var/lib/docker/volumes/` on every `docker run`. It survives `docker rm` and becomes a dangling volume unless removed with `docker rm -v`.

## Possible improvements

- Copy `package*.json` first, run `npm ci`, then copy the code (better layer caching).
- Remove `VOLUME` for application code — code belongs in the image, volumes are for data.
- Serve the static files with a lightweight web server (e.g. nginx) instead of a Node.js dev server: much smaller image.

