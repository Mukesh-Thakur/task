module "ecs" {
  source = "terraform-aws-modules/ecs/aws"

  cluster_name = var.cluster_name

  cluster_configuration = {
    execute_command_configuration = {
      logging = var.cluster_logging
      log_configuration = {
        cloud_watch_log_group_name = var.log_group_name
      }
    }
  }

  fargate_capacity_providers = var.fargate_capacity_providers

  services = {
    ecsdemo-frontend = {
      cpu    = var.frontend_cpu
      memory = var.frontend_memory

      # Container definition(s)
      container_definitions = {
        fluent-bit = {
          cpu       = var.fluent_bit_cpu
          memory    = var.fluent_bit_memory
          essential = true
          image     = var.fluent_bit_image
          firelens_configuration = {
            type = "fluentbit"
          }
          memory_reservation = var.fluent_bit_memory_reservation
        }

        ecs-sample = {
          cpu       = var.ecs_sample_cpu
          memory    = var.ecs_sample_memory
          essential = true
          image     = var.ecs_sample_image
          port_mappings = [
            {
              name          = "ecs-sample"
              containerPort = var.ecs_sample_container_port
              protocol      = "tcp"
            }
          ]
          readonly_root_filesystem = var.ecs_sample_readonly_root_filesystem
          dependencies = [
            {
              containerName = "fluent-bit"
              condition     = "START"
            }
          ]
          enable_cloudwatch_logging = var.ecs_sample_enable_cloudwatch_logging
          log_configuration = {
            logDriver = var.ecs_sample_log_driver
            options = {
              Name                    = var.ecs_sample_log_driver_name
              region                  = var.ecs_sample_log_driver_region
              delivery_stream         = var.ecs_sample_log_driver_delivery_stream
              log-driver-buffer-limit = var.ecs_sample_log_driver_buffer_limit
            }
          }
          memory_reservation = var.ecs_sample_memory_reservation
        }
      }

      service_connect_configuration = {
        namespace = var.service_connect_namespace
        service = {
          client_alias = {
            port     = var.service_connect_port
            dns_name = var.service_connect_dns_name
          }
          port_name      = var.service_connect_port_name
          discovery_name = var.service_connect_discovery_name
        }
      }

      subnet_ids = ["subnet-xxxxxxx"]
      security_group_rules = {
        alb_ingress_3000 = {
          type                     = "ingress"
          from_port                = 80
          to_port                  = 80
          protocol                 = "tcp"
          description              = "Service port"
          source_security_group_id = "sg-12345678"
        }
        egress_all = {
          type        = "egress"
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
        }
      }
    }
  }
  tags = var.tags
}
