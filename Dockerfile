FROM jenkins/jenkins

ENV JENKINS_USER admin
ENV JENKINS_PASS admin
ENV JENKINS_UC_DOWNLOAD http://ftp-nyc.osuosl.org/pub/jenkins	
ENV CASC_JENKINS_CONFIG /usr/share/jenkins/ref/jenkins.yml
# Skip initial setup
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false


COPY jenkins.yml /usr/share/jenkins/ref/jenkins.yml
COPY plugins.txt /usr/share/jenkins/plugins.txt

USER root
RUN chmod -R 777 /usr/share/jenkins/ref/jenkins.yml



RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/plugins.txt


#USER root
RUN apt-get update \
    && apt-get install -qqy apt-transport-https ca-certificates curl gnupg2 software-properties-common 
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"
RUN apt-get update  -qq \
    && apt-get install docker-ce -y
RUN usermod -aG docker jenkins
RUN apt-get clean
RUN curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose
USER jenkins

