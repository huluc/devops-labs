# Java Spring Boot App – Dockerized

Ironhack DevOps bootcamp lab: containerize a Spring Boot (Maven, Java 17) app with a Dockerfile, build the image and run it.

Source code: [ironhack-labs/sample-java-springboot-app](https://github.com/ironhack-labs/sample-java-springboot-app)

## How to run

```bash
git clone https://github.com/ironhack-labs/sample-java-springboot-app.git
cp Dockerfile sample-java-springboot-app/
cd sample-java-springboot-app
docker build -t sample-java-app .
docker run -d --name java-app -p 8080:8080 sample-java-app
curl http://localhost:8080   # Greetings from Spring Boot!
```

## Changes compared to the lab instructions

- **Base image:** `openjdk:17-jdk-alpine` was removed from Docker Hub (openjdk images are deprecated), so I used `eclipse-temurin:17-jdk-alpine`.
- **Port:** port 80 on my machine was already used by Apache, so I published the container on `8080:8080` instead of `80:8080`.
- **Container name:** added `--name java-app` instead of a random name.

## What I learned

- **Layer caching:** `pom.xml` is copied and dependencies are downloaded before the source code, so code changes don't re-trigger the slow dependency download.
- **`EXPOSE` only documents the port**; `-p host:container` actually publishes it.
- **One port, one process:** a host port can only be used by one process at a time.
- **`mvnw spring-boot:run` is a development approach:** the container compiles the code at every start and even downloads some missing dependencies at runtime (`go-offline` doesn't catch everything). It would fail without internet access.

## Possible improvement

Multi-stage build: compile a `.jar` in a JDK stage, then run only the jar on a smaller JRE image (`eclipse-temurin:17-jre-alpine`) — faster start, smaller image, no build tools in production.

