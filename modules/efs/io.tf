variable "vpc-id" {}
variable "subnet-ids-private" {}
variable "security-group-id" {}

variable "name" {}
variable "hyperkube-tag" {}

//output "depends-id" { value = "${null_resource.dummy_dependency.id}" }
output "dns_name" { value = "${ aws_efs_mount_target.alpha.dns_name }" }