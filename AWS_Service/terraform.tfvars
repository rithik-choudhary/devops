# qa_cluster = "production-apps-cluster"
# qa_cluster = "non-prod-application-cluster"
# qa_cluster = "sandbox-apps-cluster"
qa_cluster = "QA-application-cluster"

# qa_security_group = "prd-dashboard-sg"
# qa_security_group = "dev-app-sg"
# qa_security_group = "prd-microservices-app-sg" #prd
qa_security_group = "QA-application-sg"
# qa_security_group = "sandbox-payments-microservice"
# qa_security_group = "sandbox-microservices-app-sg"





subnet_name = [ "subnet-0f85ea7a436938a94","subnet-076d2bcb696eb955c" ] # prd
# subnet_name = [ "subnet-0133e140dad000778","subnet-0573bc07a10596e57" ] # qa
# subnet_name = [ "subnet-0133e140dad000778","subnet-0573bc07a10596e57" ] # qa
# subnet_name = [ "subnet-0a2b010ed79ff4e2a","subnet-07551380cf98c3388" ] # sandbox


# qa_application_lb = "prd-apps-lb"
qa_application_lb = "QA-applicaation-lb"
# qa_application_lb = "sandbox-apps-lb"
# qa_application_lb = "development-application-lb"


ECS_service_name = "test-api-service"
ECR_repository_name = "test-api-images"
ECS_task_defiantion_name = "test-api-td"
container_name = "test-api-container"
container_port = "9004"
target_group = "test-api"
tag_name_ecr = "test-api"
domain_name = "api.example.com"
rule_name = "test-api-rule"


