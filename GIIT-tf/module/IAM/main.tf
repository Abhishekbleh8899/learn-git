data "aws_iam_policy_document" "assume_role_policy" {
  
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
  
}
resource "aws_iam_role" "ec2" {
  name= var.iam_role_name

  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json

}
resource "aws_iam_instance_profile" "test_profile" {
  name = var.instance_profile_name
  role = aws_iam_role.ec2.name 
}
resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.ec2.name 
  policy_arn = var.policy_arn
}
