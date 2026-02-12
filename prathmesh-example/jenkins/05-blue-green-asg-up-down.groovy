pipeline
{
    agent any

    environment
    {
        BLUE_ASG= "ASG-Blue"
        GREEN_ASG= "ASG-green"
        SCALE_UP= 1
        SCALE_DOWN = 0
        REGION = "ap-south-1"
        USER = "ubuntu"
        AWS_DEFAULT_REGION = 'ap-south-1'
    }


    stages
    {

        stage("detecting live ASG")
        {
            steps
            {
                script
                {
                    def blue = sh(script: "aws autoscaling describe-auto-scaling-groups --auto-scaling-group-name $BLUE_ASG --query 'AutoScalingGroups[0].DesiredCapacity' --output text",
                    returnStdout: true
                    ).trim()

                    def green=sh(script: "aws autoscaling describe-auto-scaling-groups --auto-scaling-group-name $GREEN_ASG --query 'AutoScalingGroups[0].DesiredCapacity' --output text",
                    returnStdout: true 
                    ).trim()
                    
                    if(blue.toInteger() > 0)
                    {
                        env.TARGET_ASG = GREEN_ASG
                        env.OLD_ASG = BLUE_ASG
                    }
                    else
                    {
                        env.TARGET_ASG = BLUE_ASG
                        env.OLD_ASG = GREEN_ASG
                    }

                     echo " blue asg instance count $blue"
                     echo " green asg instance count $green"
                }
            }

        }

        stage("Scaling up target ASG :- TARGET_ASG" )
        {
            steps
            {
                sh """
                aws autoscaling update-auto-scaling-group --auto-scaling-group-name ${env.TARGET_ASG} --desired-capacity $SCALE_UP --region $REGION
                """
            }


        }

        stage("waiting for instance to get ready")
        {
            steps
            {
                sh "sleep 60"
            }
        }

        stage("deploying application ")
        {
            steps
            {
                sh """
                rm -r -f docker-todo
                git clone https://github.com/prathmeshbhawsar02/docker-todo.git
                          cd docker-todo
                          git checkout v1.0.7

                   """

                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-creds'
                ]]) {
                    sh '''
                    
                    cd docker-todo
                    pwd
                    export ANSIBLE_HOST_KEY_CHECKING=False
                    chmod 400 "001.pem"
                    ls -l
                     ansible-playbook -u ubuntu --private-key 001.pem -i aws_ec2.yaml playbook.yml 
                    '''
                    }
            }

        }

        stage("Getting target instance ips")
        {
            steps
            {
                script
                {

                    def instanceIds = sh(
                    script: "aws autoscaling describe-auto-scaling-groups --auto-scaling-group-name ${env.TARGET_ASG} --query 'AutoScalingGroups[0].Instances[].InstanceId' --output text",
                    returnStdout: true
                    ).trim()

                    env.INSTANCE_IPS = sh(
                    script: "aws ec2 describe-instances --instance-ids ${instanceIds} --query 'Reservations[].Instances[].PublicIpAddress' --output text",
                    returnStdout: true
                    ).trim()

                    echo "Targets IPs : ${env.INSTANCE_IPS}"

                }
            }
        }

        stage("Health check")
        {
            steps
            {
                script
                {
                    for ( ip in env.INSTANCE_IPS.split())
                    {
                        sh "curl -f http://$ip:3000 || exit 1"
                    }
                }
            }
        }

        stage("Down Scaling old ASG")
        {
            steps
            {
                sh """
                aws autoscaling update-auto-scaling-group --auto-scaling-group-name ${env.OLD_ASG} --desired-capacity $SCALE_DOWN --region $REGION
                """
            }
        }
    }
}
