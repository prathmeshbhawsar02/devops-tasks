pipeline {
    agent any

    stages {
        stage('Install Docker App via Ansible') {
            steps {
                sshagent(credentials: ['ec2-ssh-key']) {
                    sh '''
                      ssh -o StrictHostKeyChecking=no ubuntu@13.233.85.93 '
                      echo "ssh complete"
                      git clone https://github.com/knaopel/docker-frontend-backend-db.git
                      git clone https://github.com/prathmeshbhawsar02/docker-todo.git
                      cd docker-todo
                      ansible-playbook -i inventory.ini playbook.yml

                      '
                    '''
                }
            }
            
        }
       
        
        
    }
    
}
