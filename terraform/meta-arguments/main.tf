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
  key_name_prefix = "terraform-lab-"
  public_key      = file("~/.ssh/terraform-lab.pub")
}

resource "aws_security_group" "ssh" {
  name_prefix = "terraform-lab-"

  ingress {
    from_port   = 22
    to_port     = 22
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

# 2.1 depends_on
resource "aws_s3_bucket" "data_bucket" {
  bucket_prefix = "my-data-bucket-"
}

resource "aws_instance" "app_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  depends_on = [aws_s3_bucket.data_bucket]
}

# 2.2 count
resource "aws_instance" "web" {
  count         = 3
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
}

# 2.3 for_each
variable "server_names" {
  type    = set(string)
  default = ["app1", "app2", "app3"]
}

resource "aws_instance" "servers" {
  for_each      = var.server_names
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  tags = {
    Name = each.key
  }
}
# 2.4 lifecycle
resource "aws_s3_bucket" "data" {
  bucket_prefix = "my-protected-bucket-"

  lifecycle {
    prevent_destroy = false
  }
}
# 2.5 provider
provider "aws" {
  alias  = "us"
  region = "us-east-1"
}

provider "aws" {
  alias  = "eu"
  region = "eu-central-1"
}

data "aws_ami" "ubuntu_eu" {
  provider    = aws.eu
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

resource "aws_instance" "us_server" {
  provider      = aws.us
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
}

resource "aws_instance" "eu_server" {
  provider      = aws.eu
  ami           = data.aws_ami.ubuntu_eu.id
  instance_type = "t2.micro"
}

# 2.6 provisioner
resource "aws_instance" "app" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.lab.key_name
  vpc_security_group_ids = [aws_security_group.ssh.id]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/terraform-lab")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait > /dev/null || true",
      "sudo apt update -y",
      "sudo apt install nginx -y",
      "sudo systemctl start nginx"
    ]
  }
}

# 2.7 connection
resource "aws_instance" "web_ssh" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.lab.key_name
  vpc_security_group_ids = [aws_security_group.ssh.id]

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/terraform-lab")
      host        = self.public_ip
    }
    inline = ["echo Hello, Terraform!"]
  }
}