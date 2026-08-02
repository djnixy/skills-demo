module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "8.2.1"

  name = local.alb_name

  load_balancer_type = "application"

  vpc_id          = data.aws_vpc.default.id
  security_groups = [module.alb-sg.security_group_id]
  subnets         = data.aws_subnets.all.ids
  #   # See notes in README (ref: https://github.com/terraform-providers/terraform-provider-aws/issues/7987)
  #   access_logs = {
  #     bucket = module.log_bucket.s3_bucket_id
  #   }

  http_tcp_listeners = [
    # Forward action is default, either when defined or undefined
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
      # action_type        = "forward"
    # },
    # {
    #   port               = 443
    #   protocol           = "HTTPS"
    #   target_group_index = 0
    #   # action_type        = "forward"
    }    
  ]


  http_tcp_listener_rules = [
    {
      http_tcp_listener_index = 0
      priority                = 1
      actions = [{
          type               = "forward"
          target_group_index = 1
      }]

      conditions = [{
        host_headers = [var.domain_name]
        }]
      
    },
    {
      http_tcp_listener_index = 0
      priority                = 2
      actions = [{
          type               = "forward"
          target_group_index = 2
      }]

      conditions = [{
        host_headers = ["api.${var.domain_name}"]
        }]
      
    }
  ]

  target_groups = [
    {
      name                 = "tg-default"
      backend_protocol     = "HTTP"
      backend_port         = 80
      target_type          = "ip"
      deregistration_delay = 10
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }
      protocol_version = "HTTP1"
    },
    {
      name                 = local.tg_frontend_name
      backend_protocol     = "HTTP"
      backend_port         = 80
      target_type          = "ip"
      deregistration_delay = 10
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }
      protocol_version = "HTTP1"
    },
    {
      name                 = local.tg_backend_name
      backend_protocol     = "HTTP"
      backend_port         = 80
      target_type          = "ip"
      deregistration_delay = 10
      health_check = {
        enabled             = true
        interval            = 60
        path                = "/api/monitor/ping"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }
      protocol_version = "HTTP1"
    #   targets = {
    #     my_ec2 = {
    #       target_id = aws_instance.this.id
    #       port      = 80
    #     },
    #     my_ec2_again = {
    #       target_id = aws_instance.this.id
    #       port      = 8080
    #     }
    #   }
    }
  ]
}