# docker-jenkins



This project provides necessary config files to create docker images for jenkins with pre-installed role-based startegy plugin, validates few test cases and deploy the containers on remote node as docker service. 


![alt text](https://github.com/shwetab17/docker-jenkins/blob/master/arch.jpg)



Nodes involved:

1. GitHub Repository : SCM for fetching the necessary config file
2. DockerHub Repository : Docker image repository to push created docker images
3.  Jenkins Pipeline Server
4. Remote Node where the docker container running Jenkins is deployed
