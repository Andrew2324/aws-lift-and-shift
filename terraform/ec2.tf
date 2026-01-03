resource "aws_instance" "legacy_app" {
  ami                         = data.aws_ami.al2023.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.app_sg.id]
  key_name                    = var.key_name
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  associate_public_ip_address = true

  user_data = file("${path.module}/../scripts/userdata.sh")

  tags = merge(local.tags, {
    Name = "${var.project_name}-legacy-app"
  })
}
