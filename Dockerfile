# Define the build stage using Maven as base image
FROM maven:3.8.7-eclipse-temurin-17 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the pom.xml file into the Docker image before running mvn dependency:go-offline to download project dependencies
COPY pom.xml .

# Run mvn dependency:go-offline command to download project dependencies offline
RUN mvn dependency:go-offline -B

# Copy the source code into the container
COPY src ./src

# Run mvn clean package to clean and package the application
RUN mvn clean install

# Define the final stage using OpenJDK as base image
FROM openjdk:17-jdk

# Set the working directory inside the container
WORKDIR /app

# Copy the built JAR file from the build stage into the final image
COPY --from=build /app/target/backend_angularCICD-0.0.1-SNAPSHOT /app/backend_angularCICD-0.0.1-SNAPSHOT

# Expose port 8080 for the application
EXPOSE 8080

# Define the command to run the application when the container starts
CMD ["java", "-jar", "backend_angularCICD-0.0.1-SNAPSHOT.jar"]