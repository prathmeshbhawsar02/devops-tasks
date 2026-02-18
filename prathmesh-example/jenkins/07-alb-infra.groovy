    pipeline
    {
    agent any
    
    environment
    {
        ALB_NAME = "todo-app-alb"
    }


    stages
    {
            stage("checking ALB exist or not")
            {
                steps
                {
                    script
                    {
                        // def lb_exist = sh (script: "aws elbv2 describe-load-balancers --names {$ALB_NAME} --query 'LoadBalancers[0].LoadBalancerArn' --output text 2>/dev/null"
                        // returnStdout = true
                        // ).trim()
                        def status = sh(script: "aws elbv2 describe-load-balancers --names ${ALB_Name} > /dev/null 2>&1",
                        returnStatus: true
                        )
                        if( status != 0 )
                        {
                            echo "ALB not exist"
                            sh """
                            git clone https://github.com/prathmeshbhawsar02/terraform-b-g-alb.git
                            cd terraform-b-g-alb
                            terraform init
                            terraform apply -auto-approve
                            """
                        }
                        else
                        {
                            echo "alb already exists"
                        }
                        
                    }
                }
    
            }
    }    
    }