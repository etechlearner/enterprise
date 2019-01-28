#!/bin/bash
#
# This script is meant for demonstration purposes only. Use at your own risk.
#
# Install NFS libraries and configure NFS mount for /mnt/nfs
#

set -x

# pass the efs DNS name, usually ${aws_efs_mount_target.main.0.dns_name}
MOUNT_TARGET="$1"

MOUNT_LOCATION="/mnt/efs"

sudo apt-get update &&
	sudo apt-get install -y nfs-common

sudo mkdir -p $MOUNT_LOCATION

sudo mount \
	-t nfs4 \
	-o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 \
	$MOUNT_TARGET:/ $MOUNT_LOCATION

df -h | grep efs
mount | grep nfs
