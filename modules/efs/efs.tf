resource "aws_efs_file_system" "general" {
  tags {
    builtWith = "terraform"
    KubernetesCluster = "${ var.name }"
    Name = "kz8s-${ var.name }"
    version = "${ var.hyperkube-tag }"
  }
}

resource "aws_efs_mount_target" "alpha" {
  file_system_id = "${aws_efs_file_system.general.id}"
  subnet_id      = "${ element( split(",", var.subnet-ids-private), 0 ) }"
  security_groups = ["${ var.security-group-id }"]
}

resource "aws_efs_mount_target" "beta" {
  file_system_id = "${aws_efs_file_system.general.id}"
  subnet_id      = "${ element( split(",", var.subnet-ids-private), 1 ) }"
  security_groups = ["${ var.security-group-id }"]
}

resource "aws_efs_mount_target" "charlie" {
  file_system_id = "${aws_efs_file_system.general.id}"
  subnet_id = "${ element( split(",", var.subnet-ids-private), 2 ) }"
  security_groups = ["${ var.security-group-id }"]
}

//resource "null_resource" "dummy_dependency" {
//  depends_on = [
//    "aws_autoscaling_group.worker",
//    "aws_launch_configuration.worker",
//  ]
//}
