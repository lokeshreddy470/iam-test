provider "aws" {
  region = "us-east-1"
}


###################################################################
# IAM user without pgp_key (IAM access secret will be unencrypted)
###################################################################
module "iam_user" {
  source = "../../modules/iam-user"

  name = "test-terraform"
  
  create_iam_user_login_profile = false
  #create_iam_access_key         = true
}

module "iam_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "~> 2.0"

  name        = "example"
  path        = "/"
  description = "My example policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_user_policy_attachment" "test-attach" {
  user       = module.iam_user.this_iam_user_name
  policy_arn = module.iam_policy.arn
}

