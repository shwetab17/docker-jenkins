pipeline {
environment {
                registry = "bshweta/my-repository"
                registryCredential = 'dockerhub'
                dockerImage = ''
                plugin_status = ''
                role_status = ''
            } 

 agent any
 
  stages {
        stage('Build image') {
          steps{
            script {
                   dockerImage = docker.build registry + ":jenkins-$BUILD_NUMBER"
                   sh 'echo Docker Image built . . . .'
            }
          }
        }
        
        stage('Test image') {
          steps{
            script {
            /*dockerImage.inside("-u root --entrypoint='/bin/bash'") { */
            dockerImage.withRun {c ->
                sh "docker logs ${c.id}"
               plugin_status = sh "sleep 40 && if docker exec ${c.id} ls -lt /var/jenkins_home/plugins/role-strategy > /dev/nul;then echo Success; else echo Failure; fi"
               println(plugin_status)
               
               role_status = sh "sleep 40 && if docker exec ${c.id} cat /var/jenkins_home/config.xml | grep -i deployer > /dev/nul; then echo Success; else echo Failure; fi"
               println(role_status)
               
              if ( plugin_status == Failure && role_status == Failure )
              {
                currentBuild.result = 'ABORTED'
                error('Stopping early…')
                }
               
                   /*  sh 'ls /var/jenkins_home/plugins | grep "role-strategy$"'  
                    sh 'ls $JENKINS_HOME/plugins/'*/
                   /* sh 'cat $JENKINS_HOME/config.xml | grep -i deployer'*/ 
            sh 'echo Docker image Validated! Role based plgins installed & Users configured! . . . .'
        }
            }
            }
          }
        
        stage('Push Image') {
            steps{
             script {
            
               withCredentials([usernamePassword( credentialsId: 'dockerhub', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')])
               {
                 docker.withRegistry( '', registryCredential ) {
                 sh "docker login -u ${USERNAME} -p ${PASSWORD}"
                 dockerImage.push()
                 sh 'echo Docker Image Pushed to repository . . . .'
                 }
               }
            }
                
            }
         
      }
}
}

