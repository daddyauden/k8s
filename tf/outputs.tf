output "k8s-vol1-volumeID" {
  description = "volumeID with k8s-vol1"
  value = aws_ebs_volume.k8s-vol1.id
}