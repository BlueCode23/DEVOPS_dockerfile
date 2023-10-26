# syntax=docker/dockerfile:1

# Comments are provided throughout this file to help you get started.
# If you need more help, visit the Dockerfile reference guide at
# https://docs.docker.com/engine/reference/builder/

################################################################################
# Pick a base image to serve as the foundation for the other build stages in
# this file.
#
# For illustrative purposes, the following FROM command
# is using the alpine image (see https://hub.docker.com/_/alpine).
# By specifying the "latest" tag, it will also use whatever happens to be the
# most recent version of that image when you build your Dockerfile.
# If reproducability is important, consider using a versioned tag
# (e.g., alpine:3.17.2) or SHA (e.g., alpine@sha256:c41ab5c992deb4fe7e5da09f67a8804a46bd0592bfdf0b1847dde0e0889d2bff).
FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    git \
    debconf-utils \
    vim \
    curl \
    wget \
    openjdk-8-jdk \
    unzip \
&& rm -rf /var/lib/apt/lists/*

RUN wget -c https://services.gradle.org/distributions/gradle-6.7.1-bin.zip -P /tmp \
    && unzip -d /opt/gradle /tmp/gradle-6.7.1-bin.zip

RUN export DEBIAN_FRONTEND="noninteractive" \
    && apt-get update \
    && apt-get install -y debconf-utils lsb-release \
    && echo "mysql-apt-config mysql-apt-config/select-server select mysql-8.0" | debconf-set-selections \
    && wget https://dev.mysql.com/get/mysql-apt-config_0.8.14-1_all.deb \
    && dpkg -i mysql-apt-config_0.8.14-1_all.deb \
    && apt-get update \
    && echo "mysql-community-server mysql-community-server/re-root-pass password root" | debconf-set-selections \
    && echo "mysql-community-server mysql-community-server/root-pass password root" | debconf-set-selections \
    && echo "mysql-server mysql-server/root_password password root" | debconf-set-selections \
    && echo "mysql-server mysql-server/root_password_again password root" | debconf-set-selections \
    && apt-get -y install mysql-server

