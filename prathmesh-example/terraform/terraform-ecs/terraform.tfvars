region         = "ap-south-1"
backend_image  = "public.ecr.aws/e2v1e3p8/todo-app-backend:latest"
frontend_image = "public.ecr.aws/e2v1e3p8/todo-app-frontend:latest"
db_image       = "public.ecr.aws/e2v1e3p8/todo-app-mongo:latest"

subnets = ["subnet-004f7705962d6b5cd"]

security_groups = ["sg-0e94de3aa3eadfe73"]
MONGO_URL       = "mongodb://username:password@localhost:27017/todos?authSource=admin"
