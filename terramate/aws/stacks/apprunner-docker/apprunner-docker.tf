module "app_runner_service_docker" {
  source = "terraform-aws-modules/app-runner/aws"

  service_name = "example-image-base"

  instance_configuration = {
    cpu    = "256"
    memory = "512"
  }

  source_configuration = {
    image_repository = {
      image_configuration = {
        port = 8000
        runtime_environment_variables = {
          MY_VARIABLE = "hello!"
        }
      }
      image_identifier      = "public.ecr.aws/aws-containers/hello-app-runner:latest"
      image_repository_type = "ECR_PUBLIC"
    }
  }
  enable_observability_configuration = false
}