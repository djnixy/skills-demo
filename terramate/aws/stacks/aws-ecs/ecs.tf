resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/ecs/cluster-${local.cluster_name}"
  retention_in_days = "${var.environment == "dev" ? "3" : "7"}"
}

module "ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "4.1.2"
  cluster_name = local.cluster_name

  cluster_configuration = {
    execute_command_configuration = {
      logging = "OVERRIDE"
      log_configuration = {
        # You can set a simple string and ECS will create the CloudWatch log group for you
        # or you can create the resource yourself as shown here to better manage retention, tagging, etc.
        # Embedding it into the module is not trivial and therefore it is externalized
        cloud_watch_log_group_name = aws_cloudwatch_log_group.this.name
      }
    }
  }

  # Capacity provider
  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = "${var.environment == "dev" ? "1" : "0"}"
        base   = "${var.environment == "dev" ? "0" : "1"}"
      }
    }
    FARGATE_SPOT = {
      default_capacity_provider_strategy = {
        weight = "${var.environment == "dev" ? "0" : "1"}"
        base   = "${var.environment == "dev" ? "1" : "0"}"
      }
    }
  }

  
}

resource "aws_ecs_task_definition" "res-td-frontend" {
  # container_definitions    = "[{\"cpu\":0,\"environment\":[],\"essential\":true,\"image\":\"333831717381.dkr.ecr.ap-southeast-2.amazonaws.com/wooshfood-onboarding-frontend:development-109\",\"logConfiguration\":{\"logDriver\":\"awslogs\",\"options\":{\"awslogs-group\":\"/ecs/wf-onboarding-fe-dev\",\"awslogs-region\":\"ap-southeast-2\",\"awslogs-stream-prefix\":\"ecs\"}},\"mountPoints\":[],\"name\":\"app\",\"portMappings\":[{\"containerPort\":80,\"hostPort\":80,\"protocol\":\"tcp\"}],\"volumesFrom\":[]}]"
  container_definitions = <<EOF
  [
    {
      "dnsSearchDomains": null,
      "environmentFiles": null,
      "logConfiguration": {
        "logDriver": "awsfirelens",
        "secretOptions": null,
        "options": {
          "RemoveKeys": "container_id,ecs_task_arn",
          "LineFormat": "key_value",
          "Labels": "{job=\"firelens\"}",
          "LabelKeys": "container_name,ecs_task_definition,source,ecs_cluster",
          "Url": "https://loki.tc.wooshfood.com/loki/api/v1/push",
          "Name": "grafana-loki"
        }
      },
      "portMappings": [
        {
          "hostPort": 80,
          "protocol": "tcp",
          "containerPort": 80
        }
      ],
      "cpu": 0,
      "image": "nginx:latest",
      "essential": true,
      "name": "app"
    },
    {
      "logConfiguration": {
        "logDriver": "awsfirelens",
        "options": {
          "RemoveKeys": "container_id,ecs_task_arn",
          "LineFormat": "key_value",
          "Labels": "{job=\"firelens\"}",
          "LabelKeys": "container_name,ecs_task_definition,source,ecs_cluster",
          "Url": "https://loki.tc.wooshfood.com/loki/api/v1/push",
          "Name": "grafana-loki"
        }
      },
      "cpu": 0,
      "memoryReservation": 50,
      "image": "grafana/fluent-bit-plugin-loki:main",
      "firelensConfiguration": {
        "type": "fluentbit"
      },
      "essential": true,
      "name": "log_router"
    }
  ]
EOF

  cpu                      = "256"
  execution_role_arn       = var.ecsTaskExecutionRole
  family                   = local.td_frontend
  memory                   = "512"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  runtime_platform {
    operating_system_family = "LINUX"
  }

  task_role_arn = var.ecsTaskExecutionRole
}

# resource "aws_ecs_task_definition" "res-td-frontend" {
#   family = local.frontend_taskDefinition

#   container_definitions = <<EOF
# [
#   {
#     "name": "hello_world",
#     "image": "hello-world",
#     "cpu": 0,
#     "memory": 128,
#     "logConfiguration": {
#       "logDriver": "awslogs",
#       "options": {
#         "awslogs-region": "ap-southeast-1",
#         "awslogs-group": "${aws_cloudwatch_log_group.this.name}",
#         "awslogs-stream-prefix": "ecs"
#       }
#     }
#   }
# ]
# EOF
# }

resource "aws_ecs_service" "res-service-frontend" {
    cluster = local.cluster_name
    name = local.service_frontend_name 
    task_definition     = aws_ecs_task_definition.res-td-frontend.arn

#   capacity_provider_strategy {
#     base              = "0"
#     capacity_provider = "FARGATE_SPOT"
#     weight            = "1"
#   }

#   capacity_provider_strategy {
#     base              = "0"
#     capacity_provider = "FARGATE"
#     weight            = "1"
#   }



#   deployment_circuit_breaker {
#     enable   = "false"
#     rollback = "false"
#   }

#   deployment_controller {
#     type = "ECS"
#   }

#   deployment_maximum_percent         = "200"
#   deployment_minimum_healthy_percent = "100"
  desired_count                      = "1"
  enable_ecs_managed_tags            = "true"
  enable_execute_command             = "true"
  health_check_grace_period_seconds  = "0"

  load_balancer {
    container_name   = "app"
    container_port   = "80"
    target_group_arn = module.alb.target_group_arns[1]
  }

  network_configuration {
    assign_public_ip = "true"
    security_groups  = [module.ecs-frontend-sg.security_group_id]
    subnets          = data.aws_subnets.all.ids
  }

#   platform_version    = "LATEST"
#   scheduling_strategy = "REPLICA"

}

# resource "aws_cloudwatch_log_group" "this" {
#   name_prefix       = "hello_world-"
#   retention_in_days = 1
# }

# resource "aws_ecs_service" "this" {
#   name            = local.frontend_serviceName
#   cluster         = local.cluster_name
#   task_definition = aws_ecs_task_definition.this.arn

#   desired_count = 1

#   deployment_maximum_percent         = 100
#   deployment_minimum_healthy_percent = 0
# }