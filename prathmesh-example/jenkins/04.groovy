pipeline {
    agent any

    parameters {
        choice(
            name: 'VERSION',
            choices: ['v1.0.0', 'v1.0.7'],
            description: 'Choose application version'
        )
    }

    environment {
        AWS_DEFAULT_REGION = 'ap-south-1'
    }

    stages {

        stage('Checkout Application Code') {
            steps {
                script {
                    if (params.VERSION == 'v1.0.0') {
                        sh '''
                          git clone https://github.com/knaopel/docker-frontend-backend-db.git
                          git clone https://github.com/prathmeshbhawsar02/docker-todo.git
                          cd docker-todo
                          git checkout v1.0.0
                        '''
                    }

                    if (params.VERSION == 'v1.0.7') {
                        sh '''
                          rm -r -f docker-todo
                          git clone https://github.com/prathmeshbhawsar02/docker-todo.git
                          cd docker-todo
                          git checkout v1.0.7
                        '''
                    }
                }
            }
        }

        stage('Run Ansible (AWS Dynamic Inventory)') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-creds'
                ]]) {
                    sh '''
                    
                    cd docker-todo
                      ansible-playbook -u ubuntu --private-key 001.pem -i aws_ec2.yaml playbook.yml 
                    '''
                }
            }
        }
    }
}