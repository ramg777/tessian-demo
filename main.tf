# Define provider and AWS region
provider "aws" {
  region = "eu-west-1" 
}


# Create an ECS cluster
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "ecs_cluster"
}

# Create a task definition for the ECS service
resource "aws_ecs_task_definition" "task_definition" {
  family                   = "task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"] # Stating that we are using ECS Fargate
  memory                   = 512         # Specifying the memory our container requires
  cpu                      = 256         # Specifying the CPU our container requires
  execution_role_arn       = "${aws_iam_role.ecsTaskExecutionRole.arn}"
  container_definitions    = <<DEFINITION
  [
    {
      "name": "my-container",
      "image": "${data.aws_ecr_repository.poetry-image-push.repository_url}", 
      "portMappings": [
        {
          "containerPort": 8000,
          "hostPort": 8000,
          "protocol": "tcp"
        }
      ]
    }
  ]
  DEFINITION

}

# Create an ECS service
resource "aws_ecs_service" "ecs_service" {
  name            = "ecs-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.task_definition.arn
  desired_count   = 1

  network_configuration {
    subnets          = [aws_subnet.public.id]
    security_groups  = [aws_security_group.ecs_sg.id]
  }
}