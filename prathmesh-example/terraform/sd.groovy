pipeline {
    agent any

    parameters {
        choice(
            name: 'TF_ACTION',
            choices: ['apply', 'destroy'],
            description: 'Choose Terraform action'
        )
    }

    environment {
        AWS_DEFAULT_REGION = 'ap-south-1'
    }

    stages {

        stage('Checkout Code') {
            when {
                expression { params.TF_ACTION == 'apply' }
            }
            steps {
                git url: 'https://github.com/prathmeshbhawsar02/terraform-ansible-docker-todo-app.git'
            }
        }

        stage('Terraform Init') {
            when {
                expression { params.TF_ACTION == 'apply' }
            }
            steps {
                sh 'terraform init'
            }
        }

        stage('Terraform Apply') {
            when {
                expression { params.TF_ACTION == 'apply' }
            }
            steps {
                sh 'terraform apply -auto-approve'
            }
        }

        stage('Terraform Destroy') {
            when {
                expression { params.TF_ACTION == 'destroy' }
            }
            steps {
                sh 'terraform destroy -auto-approve'
            }
        }
    }

    post {
        success {
            echo "Terraform ${params.TF_ACTION} completed successfully"
        }
    }
}