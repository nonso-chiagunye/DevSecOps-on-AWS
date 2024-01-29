
resource "aws_security_group" "ike_alb_sg" {
  vpc_id      = aws_vpc.ike_vpc.id
  name        = var.lb_security_group
  description = "Load Balancer Security Group"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

   dynamic "ingress" {
    for_each = var.lb_ports
    content {
        from_port = ingress.value
        to_port = ingress.value
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
  }

  tags = {
    Name = var.lb_security_group
  }
}


