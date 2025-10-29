# Stage 1: Build JAR
FROM ubuntu:22.04 AS builder

# ثبّت Java 21 و Maven
RUN apt-get update && apt-get install -y openjdk-21-jdk maven

WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests -Denforcer.skip=true

# Stage 2: Create runtime image
FROM openjdk:21-jdk-slim
WORKDIR /app
COPY --from=builder /app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","app.jar"]

