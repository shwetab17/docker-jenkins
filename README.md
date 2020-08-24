# docker-jenkins



This project provides necessary config files to create docker images for jenkins with pre-installed role-based startegy plugin, validates few test cases and deploy the containers on remote node as docker service. 

Nodes involved:

GitHub Repository : SCM for fetching the necessary config file

DockerHub Repository : Docker image repository to push created docker images

HOST 1 : Jenkins Pipeline Server

HOST 2 : Remote Node where the docker container running Jenkins is deployed
