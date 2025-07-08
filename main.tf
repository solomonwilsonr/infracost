provider "aws" {
  region = "us-west-2"
}

resource "aws_key_pair" "my_key" {
  key_name   = "my-key"
  public_key = file("~/.ssh/id_rsa.pub") # Make sure this file exists
}

resource "aws_security_group" "ec2_sg" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"

  ingress {
    description = "SSH"
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

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 in us-east-1
  instance_type = "t2.micro"
  key_name      = aws_key_pair.my_key.key_name
  security_groups = [aws_security_group.ec2_sg.name]

  tags = {
    Name = "MySimpleEC2"
  }
}
