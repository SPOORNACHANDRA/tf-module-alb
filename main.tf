resource "aws_lb" "main" {
  name               = "${var.env}-alb"
  internal           = var.internal
  load_balancer_type = var.lb_type
  security_groups    = [aws_security_group.main.id]
  subnets            = [for subnet in aws_subnet.public : subnet.id]

  enable_deletion_protection = true

  access_logs {
    bucket  = aws_s3_bucket.lb_logs.id
    prefix  = "test-lb"
    enabled = true
  }

  tags = {
    Environment = "production"
  }
}



resource "aws_security_group" "allow_tls" {
  name        = "${var.env}-alb-sg"
  description = "${var.env}-alb-sg"
  vpc_id      = var.vpc_id
  tags = merge(local.tags),{name = "${var.env}-alb-sg"})

  ingress {
    description      = "TLS from VPC"
    from_port        = var.sg_port
    to_port          = var.sg_port
    protocol         = "tcp"
    cidr_blocks      = var.sg_ingress_cidr
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}
