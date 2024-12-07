FROM jenkins/jenkins:latest

USER root

RUN apt update && apt install -y maven

USER jenkins