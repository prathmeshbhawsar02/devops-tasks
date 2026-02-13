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
        ALB_NAME = "todo-app-alb"
    }


    stages
    {
        // stage("checking ALB exist or not")
        // {
        //     steps
        //     {
        //         script
        //         {
        //             // def lb_exist = sh (script: "aws elbv2 describe-load-balancers --names {$ALB_NAME} --query 'LoadBalancers[0].LoadBalancerArn' --output text 2>/dev/null"
        //             // returnStdout = true
        //             // ).trim()
        //             def status = sh(script: "aws elbv2 describe-load-balancers --names ${ALB_Name} > /dev/null 2>&1",
        //             returnStatus: true
        //             )
        //             if( status != 0 )
        //             {
        //                 echo "ALB not exist"
        //                 sh """
        //                 git clone https://github.com/prathmeshbhawsar02/terraform-b-g-alb.git
        //                 cd terraform-b-g-alb
        //                 terraform init
        //                 terraform apply -auto-approve
        //                 """
        //             }
        //             else
        //             {
        //                 echo "alb already exists"
        //             }
                    
        //         }
        //     }
        // }



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
                sh "sleep 120"
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
                ]]) 
                {
                    script
                    {
                        try{
                        sh '''
                        
                        cd docker-todo
                        export ANSIBLE_HOST_KEY_CHECKING=False
                        chmod 400 "001.pem"
                        ansible-playbook -u ubuntu --private-key 001.pem -i aws_ec2.yaml playbook.yml 
                        ''' 
                        }
                        catch (err)
                            {
                                echo "!!!!!!!   deployment asg issue via ansible......"
                            }
                        }
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
        stage("waiting for deployement to be done")
        {
            steps
            {
                sh "sleep 120"
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

        stage("switching ALB listner to target")
        {
            steps
            {
                script
                {
                    def tg_arn = sh(script: "aws autoscaling describe-auto-scaling-groups --auto-scaling-group-names ${TARGET_ASG} --query 'AutoScalingGroups[0].TargetGroupARNs[0]' --output text",
                        returnStdout: true
                    ).trim()

                    def alb_arn = sh(script: "aws elbv2 describe-load-balancers --names ${ALB_NAME} --query 'LoadBalancers[0].LoadBalancerArn' --output text",
                        returnStdout: true
                    ).trim() 

                    def listner_arn = sh(script: "aws elbv2 describe-listeners --load-balancer-arn ${alb_arn} --query 'Listeners[?Port==`3000`].ListenerArn' --output text",
                        returnStdout: true
                    ).trim()


                     sh """
                     aws elbv2 modify-listener --listener-arn ${listner_arn} --default-actions Type=forward,TargetGroupArn=${tg_arn}
                     """
                     echo "Swwitched to ${TARGET_ASG}"

                     echo "DNS of ALB is ---"

                     sh "aws elbv2 describe-load-balancers --names todo-app-alb --query 'LoadBalancers[0].DNSName' --output text"                }
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
