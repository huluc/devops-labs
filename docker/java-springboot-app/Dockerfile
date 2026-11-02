# Base image (openjdk:17-jdk-alpine was removed from Docker Hub)
FROM eclipse-temurin:17-jdk-alpine

WORKDIR /app
EXPOSE 8080

# 1) Copy only the build files first
COPY .mvn/ .mvn
COPY mvnw pom.xml ./

# 2) Download all dependencies (cached layer)
RUN ./mvnw dependency:go-offline

# 3) Copy the source code
COPY src ./src

# Start the app
CMD ["./mvnw", "spring-boot:run"]