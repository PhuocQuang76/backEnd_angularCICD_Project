# Use an official Ubuntu as a base image
FROM ubuntu:latest

# Install necessary tools (curl, gnupg, apt-transport-https, etc.)
RUN apt-get update \
    && apt-get install -y curl gnupg apt-transport-https

# Install OpenJDK 17
RUN apt-get install -y openjdk-17-jdk

# Switch to the root user to install Maven
USER root

# Install Maven
RUN apt-get update && apt-get install -y maven

# Set JAVA_HOME and M2_HOME environment variables
ENV JAVA_HOME /usr/lib/jvm/java-17-openjdk-amd64
ENV M2_HOME /usr/share/maven

# Download Jenkins repository key and add it to the keyring
RUN curl -fsSL https://pkg.jenkins.io/debian/jenkins.io-2023.key | gpg --dearmor -o /usr/share/keyrings/jenkins-keyring.gpg

# Add Jenkins repository to the sources list
RUN echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.gpg] https://pkg.jenkins.io/debian binary/" > /etc/apt/sources.list.d/jenkins.list

# Update package list to include the Jenkins repository
RUN apt-get update

# Install Jenkins
RUN apt-get install -y jenkins

# Expose Jenkins port (9091) to the host
EXPOSE 9091

# Start Jenkins service
CMD java -jar /usr/share/jenkins/jenkins.war