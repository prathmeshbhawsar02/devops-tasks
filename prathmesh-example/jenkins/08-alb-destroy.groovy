pipeline
{
    agent any
    stages
    {
        stage("Terraform destroy")
        {
            steps
            {
                sh"""
                cd ..
                cd alb-infra/terraform-b-g-alb
                pwd
                terraform destroy -auto-approve
            """
            }

        }
    }
}