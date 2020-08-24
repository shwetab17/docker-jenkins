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
        stage('Build image') {													/* Build docker image & tag it */
          steps{
            script {
                   dockerImage = docker.build registry + ":jenkins-$BUILD_NUMBER"
                   sh 'echo Docker Image built . . . .'
                   }
				}
							}      
        stage('Test image') {													/* Validate docker image for installed roles & plugin */
          steps{
            script {
					   dockerImage.withRun {c ->
					   sh "docker logs ${c.id}"
					   plugin_status = sh "sleep 40 && if docker exec ${c.id} ls -lt /var/jenkins_home/plugins/role-strategy;then echo Success; else echo Failure; fi"
					   println(plugin_status)
					   
					   role_status = sh "sleep 40 && if docker exec ${c.id} cat /var/jenkins_home/config.xml | grep -i deployer; then echo Success; else echo Failure; fi"
					   println(role_status)
					   
					  if ( plugin_status == Failure && role_status == Failure )
					  {
						currentBuild.result = 'ABORTED'
						error('Stopping early…')
						}
					   
						   /*  sh 'ls /var/jenkins_home/plugins | grep "role-strategy$"'  
							sh 'ls $JENKINS_HOME/plugins/'*/
						   /* sh 'cat $JENKINS_HOME/config.xml | grep -i deployer'*/ 
							sh 'echo Docker image Validated! Role based plugins installed and Users configured! . . . .'
											}
					}
				}
				}
        
        stage('Push Image') {														/* Push Image to DockerHub */
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
        stage('Deploy app') {														/* Deploy service on remote node with newly created image */
				agent { 
						label 'deployer-agent'
					   }
				steps {
				sh 'sed -i "s|CS_IMAGE=.*|CS_IMAGE=bshweta/my-repository:jenkins-$BUILD_NUMBER|g" /opt/cs-app/env.sh'
				sh 'echo Updated env for deploying docker service are:  && cat /opt/cs-app/env.sh'
				sh 'source /opt/cs-app/env.sh && bash /opt/cs-app/wrapper.sh '
				}
        }
}
    post {
        success {
            echo 'App deployment is successful. . . .'
				}
		}

}

