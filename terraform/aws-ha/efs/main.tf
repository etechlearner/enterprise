data "aws_vpc" "main" {
  id = "${var.vpc-id}"
}

resource "aws_efs_file_system" "main" {
  tags {
    Name = "${var.name}"
  }
}

resource "aws_efs_mount_target" "main" {
  count = "${var.subnets-count}"

  file_system_id = "${aws_efs_file_system.main.id}"
  subnet_id      = "${element(var.subnets, count.index)}"

  security_groups = [
    "${aws_security_group.efs.id}",
  ]
}

resource "aws_security_group" "efs" {
  name        = "efs-mnt"
  description = "Allows NFS/EFS traffic within the VPC."
  vpc_id      = "${var.vpc-id}"

  ingress {
    from_port = 2049
    to_port   = 2049
    protocol  = "tcp"

    cidr_blocks = [
      "${data.aws_vpc.main.cidr_block}",
    ]
  }

  egress {
    from_port = 2049
    to_port   = 2049
    protocol  = "tcp"

    cidr_blocks = [
      "${data.aws_vpc.main.cidr_block}",
    ]
  }

  tags {
    Name = "allow-efs"
  }
}
