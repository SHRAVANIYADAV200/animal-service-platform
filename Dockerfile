# Stage 1: Build
FROM maven:3.8.5-eclipse-temurin-17 AS build
WORKDIR /app

# Copy the pom.xml and download dependencies
COPY backend/animalservice/pom.xml ./backend/animalservice/
WORKDIR /app/backend/animalservice
RUN mvn dependency:go-offline -B

# Copy the source code and build
WORKDIR /app
COPY backend/animalservice/src ./backend/animalservice/src
WORKDIR /app/backend/animalservice
RUN mvn clean package -DskipTests

# Stage 2: Run
FROM eclipse-temurin:17-jre
WORKDIR /app

# Copy the built jar
COPY --from=build /app/backend/animalservice/target/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
