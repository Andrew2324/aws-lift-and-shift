# Attach CloudWatchAgentServerPolicy to your existing EC2 role
# You must point "role =" to the IAM role used by your EC2 instance profile.

resource "aws_iam_role_policy_attachment" "cw_agent" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}
