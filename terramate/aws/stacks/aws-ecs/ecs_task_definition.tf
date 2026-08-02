# resource "aws_ecs_task_definition" "tfer--task-002D-definition-002F-wf-002D-onboarding-002D-be-002D-dev" {
#   container_definitions    = "[{\"cpu\":0,\"environment\":[],\"essential\":true,\"firelensConfiguration\":{\"options\":{\"enable-ecs-log-metadata\":\"true\"},\"type\":\"fluentbit\"},\"image\":\"grafana/fluent-bit-plugin-loki:main\",\"logConfiguration\":{\"logDriver\":\"awslogs\",\"options\":{\"awslogs-create-group\":\"true\",\"awslogs-group\":\"/firelens-container\",\"awslogs-region\":\"ap-southeast-2\",\"awslogs-stream-prefix\":\"firelens\"}},\"memoryReservation\":50,\"mountPoints\":[],\"name\":\"log_router\",\"portMappings\":[],\"user\":\"0\",\"volumesFrom\":[]},{\"cpu\":0,\"environment\":[{\"name\":\"APP_PORT\",\"value\":\"80\"},{\"name\":\"DB_HOST\",\"value\":\"wooshfood-onboarding-dev.cluster-crzde6nqrnsz.ap-southeast-2.rds.amazonaws.com\"},{\"name\":\"DB_PASSWORD\",\"value\":\"4NHvjp54jo8ql1I0SZdNi9w2GtCFiQHS\"},{\"name\":\"DB_PORT\",\"value\":\"3306\"},{\"name\":\"DB_USERNAME\",\"value\":\"admin\"}],\"essential\":true,\"image\":\"333831717381.dkr.ecr.ap-southeast-2.amazonaws.com/wooshfood-onboarding-backend:development-112\",\"logConfiguration\":{\"logDriver\":\"awsfirelens\",\"options\":{\"LabelKeys\":\"container_name,ecs_task_definition,source,ecs_cluster\",\"Labels\":\"{job=\\\"firelens\\\"}\",\"LineFormat\":\"key_value\",\"Name\":\"grafana-loki\",\"RemoveKeys\":\"container_id,ecs_task_arn\",\"Url\":\"http://13.237.162.97:3100/loki/api/v1/push\"}},\"mountPoints\":[],\"name\":\"app\",\"portMappings\":[{\"containerPort\":80,\"hostPort\":80,\"protocol\":\"tcp\"}],\"volumesFrom\":[]}]"
#   cpu                      = "256"
#   execution_role_arn       = var.ecsTaskExecutionRole
#   family                   = "wf-onboarding-be-dev"
#   memory                   = "512"
#   network_mode             = "awsvpc"
#   requires_compatibilities = ["FARGATE"]

#   runtime_platform {
#     operating_system_family = "LINUX"
#   }

#   task_role_arn = var.ecsTaskExecutionRole
# }

# resource "aws_ecs_task_definition" "tfer--task-002D-definition-002F-wf-002D-onboarding-002D-fe-002D-dev" {
#   container_definitions    = "[{\"cpu\":0,\"environment\":[],\"essential\":true,\"image\":\"333831717381.dkr.ecr.ap-southeast-2.amazonaws.com/wooshfood-onboarding-frontend:development-109\",\"logConfiguration\":{\"logDriver\":\"awslogs\",\"options\":{\"awslogs-group\":\"/ecs/wf-onboarding-fe-dev\",\"awslogs-region\":\"ap-southeast-2\",\"awslogs-stream-prefix\":\"ecs\"}},\"mountPoints\":[],\"name\":\"app\",\"portMappings\":[{\"containerPort\":80,\"hostPort\":80,\"protocol\":\"tcp\"}],\"volumesFrom\":[]}]"
#   cpu                      = "256"
#   execution_role_arn       = var.ecsTaskExecutionRole
#   family                   = "wf-onboarding-fe-dev"
#   memory                   = "512"
#   network_mode             = "awsvpc"
#   requires_compatibilities = ["FARGATE"]

#   runtime_platform {
#     operating_system_family = "LINUX"
#   }

#   task_role_arn = var.ecsTaskExecutionRole
# }
