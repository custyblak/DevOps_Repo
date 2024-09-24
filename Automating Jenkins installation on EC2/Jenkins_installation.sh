#!/bin/bash

sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update -y
sudo apt-get install jenkins -y
sudo apt update -y
sudo apt install fontconfig openjdk-17-jre -y

sudo systemctl enable jenkins

sudo cat /var/lib/jenkins/secrets/initialAdminPassword > passwd.txt
























#"""sudo apt update -y
#sudo apt install fontconfig openjdk-17-jre -y && sudo apt install wget -y
#mkdir Jenkins && sudo chmod -R 775 Jenkins/
#cd Jenkins
#sudo wget https://updates.jenkins-ci.org/latest/jenkins.war
#java -jar jenkins.war --httpPort=9090 &
#sudo cat /var/lib/jenkins/secrets/initialAdminPassword > psswd.txt"""