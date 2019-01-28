# Sample AWS-based HA

This Terraform configuration creates a multi-AZ HA setup which can be used as
the foundation for an HA deployment of Stoplight. The configuration consists of
two EC2 instances (in separate AZs) with a shared EFS/NFS mount. Only the basic
infrastructure-level components are addressed, and not the
installation/configuration of Stoplight itself or other application-level
concerns (load-balancers, elastic IPs, firewall rules).

> The accompanying Terraform configuration should be used for **testing purposes
> only**. This is not meant for a production-grade deployment. Please consult
> with Stoplight Support prior to deploying Stoplight in an HA configuration.

To get started:

```bash
# expose AWS credentials to the Terraform run-time
export TF_VAR_aws_access_key="XXXXXXXX"
export TF_VAR_aws_secret_key="XXXXXXXXXXXXXXXXXXXX"

# make it happen
terraform init
terraform apply
```

Contact customers@stoplight.io with any questions.

Special thanks to Ciro Costa for writing [this great article on
EFS](https://ops.tips/gists/how-aws-efs-multiple-availability-zones-terraform/#creating-a-multi-az-aws-efs-set-up-with-terraform).
