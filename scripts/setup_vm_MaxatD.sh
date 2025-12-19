#!/bin/bash
set -e

# Log file
LOG_FILE="/opt/devops-project/logs/setup.log"
mkdir -p /opt/devops-project/logs

echo "Starting setup..." | tee -a "$LOG_FILE"

# Update OS
echo "Updating OS..." | tee -a "$LOG_FILE"
sudo apt-get update && sudo apt-get upgrade -y

# Install tools
echo "Installing Java 17, Gradle, Git..." | tee -a "$LOG_FILE"
sudo apt-get install -y openjdk-17-jdk git curl unzip

# Install Gradle (MANUAL as apt version might be old)
if ! command -v gradle &> /dev/null; then
    wget -q https://services.gradle.org/distributions/gradle-8.5-bin.zip
    sudo mkdir -p /opt/gradle
    sudo unzip -d /opt/gradle gradle-8.5-bin.zip
    sudo ln -s /opt/gradle/gradle-8.5/bin/gradle /usr/bin/gradle
    rm gradle-8.5-bin.zip
fi

# Verification
echo "Verifying versions..." | tee -a "$LOG_FILE"
java -version 2>&1 | tee -a "$LOG_FILE"
gradle -version 2>&1 | tee -a "$LOG_FILE"
git --version 2>&1 | tee -a "$LOG_FILE"

echo "Setup complete!" | tee -a "$LOG_FILE"
