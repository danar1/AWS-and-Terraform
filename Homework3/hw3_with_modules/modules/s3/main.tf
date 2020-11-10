##################################################################################
# Bucket, Role (ec2 iam), instance profile
##################################################################################

# S3 bucket
resource "aws_s3_bucket" "s3-bucket" {
  bucket = var.bucket
  acl    = var.acl

  tags                    = merge(var.tags, var.s3_tags)  
}

# EC2 IAM role
resource "aws_iam_role" "ec2-iam-role" {
  name = var.role_name
  tags = merge(var.tags, var.ec2_iam_role_tags)  
  

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# Provides an IAM role inline policy 
resource "aws_iam_role_policy" "s3-write-policy-to-ec2-role" {
  name = var.s3_policy_name
  role = aws_iam_role.ec2-iam-role.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": [
                "arn:aws:s3:::${var.bucket}",
                "arn:aws:s3:::${var.bucket}/*"
            ]
    }
  ]
}
EOF

}


# Instance profile - Create instance profile with the ec2 iam role
resource "aws_iam_instance_profile" "instance_profile" {
  name = "${var.role_name}_instance_profile"
  role = aws_iam_role.ec2-iam-role.name
}
