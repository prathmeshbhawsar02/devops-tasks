pipeline {
    agent any

    parameters {
        choice(
            name: 'VERSION',
            choices: ['v1.0.0', 'v1.0.3'],
            description: 'choose app version'
        )
    }

    stages {
        stage('Install Docker App via Ansible') {
            steps {
                sshagent(credentials: ['ec2-ssh-key']) {
                    sh """
                      VERSION=${params.VERSION}
                      ssh -o StrictHostKeyChecking=no ubuntu@3.110.116.91 '
                      echo "ssh complete"
                      sudo apt -y update 
                      sudo apt install -y git
                      sudo apt install -y ansible

                      if [ "${VERSION}" = "v1.0.0" ]; then
                         echo "deploying v1.0.0 "

                         git clone https://github.com/knaopel/docker-frontend-backend-db.git                      
                         git clone https://github.com/prathmeshbhawsar02/docker-todo.git
                         cd docker-todo
 
                         git fetch --tags
                         git checkout "${VERSION}"
                      fi



                      if [ "${VERSION}" = "v1.0.2" ]; then
                         echo "deploying v1.0.2"
                         git clone https://github.com/prathmeshbhawsar02/docker-todo.git
                         cd docker-todo
                         git fetch --tags
                         git checkout "${VERSION}"
                      fi 
                    
                    ansible-playbook -i inventory.ini playbook.yml

                      '
                    """
                }
            }
            
        }
               
    }
    
}
