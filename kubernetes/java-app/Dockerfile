# --------- Build Stage ---------
FROM eclipse-temurin:11-jdk AS build
WORKDIR /app
COPY HelloController.java .
RUN javac HelloController.java
RUN jar cfe app.jar HelloController *.class

# --------- Run Stage ---------
FROM eclipse-temurin:11-jre
WORKDIR /app
COPY --from=build /app/app.jar .
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]