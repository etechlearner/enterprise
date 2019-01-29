provider "aws" {
  region     = "${var.region}"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}

module "networking" {
  source = "./networking"
  cidr   = "10.0.0.0/16"

  "az-subnet-mapping" = "${var.az-subnet-mapping}"
}

module "efs" {
  source = "./efs"

  name          = "shared-fs"
  subnets-count = "${length(var.az-subnet-mapping)}"
  subnets       = "${values(module.networking.az-subnet-id-mapping)}"
  vpc-id        = "${module.networking.vpc-id}"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "aws_vpc" "main" {
  id = "${module.networking.vpc-id}"
}

resource "aws_security_group" "allow-ssh" {
  name = "allow-ssh"

  description = "Allows SSH traffic + egress."
  vpc_id      = "${module.networking.vpc-id}"

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

  tags {
    Name = "allow-ssh"
  }
}

#
# Test key, located in './keys' directory
#
resource "aws_key_pair" "main" {
  key_name   = "deploy-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDcFM9sW/j1ptmvXlsjy3BU1traQKJGubAWv3TWFp3yy1sJcW0DT2DzcnJwC1stQzGOHojO4YmhCpttyzEvy92rRyznOJCOrBN6bGHEj/H1hIex540QGV6BSlWaGXWF+pwM/s7Jd2I4XgZbXK4feHfwUDEb2feCYrqIhTYqr4mVYlNak09N09HP5d2g5qlfu4LZ7jrGZVuGfnWxMMk3tw2EDke0FcB9syUBm2iNLn4emdiDcsT2DGiDNP3SIPOT2Jubk/wdr5BpUHOkUKWiRALS6p5J8iuUhn+w/XOmZzQsm+O/Cfs30j68NsynBxk/mWNjZaXa2ZhzHNcyGutJUONv customers@stoplight.io"
}

resource "aws_instance" "stoplight-a" {
  ami               = "${data.aws_ami.ubuntu.id}"
  instance_type     = "${var.instance-size}"
  key_name          = "${aws_key_pair.main.key_name}"
  availability_zone = "us-east-1a"
  subnet_id         = "${module.networking.az-subnet-id-mapping["us-east-1a"]}"

  vpc_security_group_ids = [
    "${aws_security_group.allow-ssh.id}",
  ]

  tags {
    Name = "stoplight-a"
  }

  provisioner "file" {
    source      = "scripts/nfs_bootstrap.sh"
    destination = "/tmp/nfs_bootstrap.sh"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file("./keys/aws-testing.pem")}"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/nfs_bootstrap.sh",
      "/tmp/nfs_bootstrap.sh ${module.efs.efs-mount-target-dns}",
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file("./keys/aws-testing.pem")}"
    }
  }
}

resource "aws_instance" "stoplight-b" {
  ami               = "${data.aws_ami.ubuntu.id}"
  instance_type     = "${var.instance-size}"
  key_name          = "${aws_key_pair.main.key_name}"
  availability_zone = "us-east-1b"
  subnet_id         = "${module.networking.az-subnet-id-mapping["us-east-1b"]}"

  vpc_security_group_ids = [
    "${aws_security_group.allow-ssh.id}",
  ]

  tags {
    Name = "stoplight-b"
  }

  provisioner "file" {
    source      = "scripts/nfs_bootstrap.sh"
    destination = "/tmp/nfs_bootstrap.sh"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file("./keys/aws-testing.pem")}"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/nfs_bootstrap.sh",
      "/tmp/nfs_bootstrap.sh ${module.efs.efs-mount-target-dns}",
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file("./keys/aws-testing.pem")}"
    }
  }
}
