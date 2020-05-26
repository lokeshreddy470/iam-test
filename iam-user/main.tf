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

from xlwings import Workbook, Range, Sheet
import pandas as pd
import os

# Alternative method to split an Excel worksheet into multiple sheets based on a column name.
# The script will prompt four questions to enter in the required information. The workbook will then open and
# split the prompted worksheet into separate worksheets based on the desired column name.
# To run, open the command prompt and enter the command python Split_Excel_Worksheet_v2.py

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Script
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

path = raw_input('Enter folder path of workbook containing worksheet to split: ')
worksheet = raw_input('Enter workbook name with extension, e.g. example.xlsx: ')
sheet = raw_input('Enter worksheet name to split: ')
column = raw_input('Enter column name to split worksheet data on: ')

workbook = os.path.join(path, worksheet)
wb = Workbook(workbook)

data = pd.DataFrame(pd.read_excel(workbook, sheet, index_col=None, na_values=[0]))
data.sort(column, axis = 0, inplace = True)

split = data.groupby(column)
for i in split.groups:
    Sheet.add()
    Range('A1', index = False).value = split.get_group(i)
