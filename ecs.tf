resource "aws_ecs_cluster" "pospisilv_lesson7" {
  name = "pospisilv_lesson7"
  
  setting {
    name = "containerInsights"
    value = "enabled"
  }
  
  tags = {
    Name = "${var.project_name}-cluster"
  }
  
}

resource "aws_ecs_task_definition" "pospisilv_lesson7" {
  family                   = "pospisilv_lesson7"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "nginx"
      image     = var.docker_nginx_image
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]
	  
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group" = aws_cloudwatch_log_group.nginx.name
          "awslogs-region" = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }

      essential = true	  
	  
    }
  ])
  
  tags = {
    Name = "${var.project_name}-task"
  }
}


resource "aws_ecs_service" "pospisilv_lesson7" {
  name            = "pospisilv_lesson7"
  cluster        = aws_ecs_cluster.pospisilv_lesson7.id
  task_definition = aws_ecs_task_definition.pospisilv_lesson7.arn
  desired_count   = 2

  launch_type = "FARGATE"

  network_configuration {
    subnets          = [data.aws_subnets.ecssubnets.ids[0], data.aws_subnets.ecssubnets.ids[1]]
    security_groups  = [aws_security_group.ecs_tasks.id]
    assign_public_ip = true
  }

  load_balancer {
      target_group_arn = aws_lb_target_group.nginx.arn
      container_name   = "nginx"
      container_port   = 80
  }
  
  depends_on = [aws_lb_listener.nginx]
  
  tags = {
    Name = "${var.project_name}-cluster"
  }
}

