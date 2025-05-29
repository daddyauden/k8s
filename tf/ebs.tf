resource "aws_ebs_volume" "k8s-vol1" {
  size              = 1
  availability_zone = "ca-central-1a"
  type = "gp3"

  tags = {
    Name = "k8s-vol1"
  }
}