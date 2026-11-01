provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

resource "aws_key_pair" "lab" {
  key_name_prefix = "roles-lab-"
  public_key      = file("~/.ssh/terraform-lab.pub")
}

# Load balancer: SSH + HTTP from anywhere
resource "aws_security_group" "lb" {
  name_prefix = "roles-lab-lb-"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Web server: SSH from anywhere, HTTP only from the load balancer
resource "aws_security_group" "web" {
  name_prefix = "roles-lab-web-"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.lb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.lab.key_name
  vpc_security_group_ids = [aws_security_group.web.id]
  tags = { Name = "roles-lab-web1" }
}

resource "aws_instance" "lb" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.lab.key_name
  vpc_security_group_ids = [aws_security_group.lb.id]
  tags = { Name = "roles-lab-lb1" }
}

output "web_public_ip" {
  value = aws_instance.web.public_ip
}

output "lb_public_ip" {
  value = aws_instance.lb.public_ip
}
