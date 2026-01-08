## The Problem
The DevOps team has been tasked with creating a secure DynamoDB table and enforcing fine-grained access control using IAM. This setup will allow secure and restricted access to the table from trusted AWS services only.

As a member of the Nautilus DevOps Team, your task is to perform the following using Terraform:

1. Create a DynamoDB Table: Create a table named xfusion-table with minimal configuration.

2. Create an IAM Role: Create an IAM role named xfusion-role that will be allowed to access the table.

3. Create an IAM Policy: Create a policy named xfusion-readonly-policy that should grant read-only access (GetItem, Scan, Query) to the specific DynamoDB table and attach it to the role.

4. Create the main.tf file (do not create a separate .tf file) to provision the table, role, and policy.

5. Create the variables.tf file with the following variables:
  - KKE_TABLE_NAME: name of the DynamoDB table
  - KKE_ROLE_NAME: name of the IAM role
  - KKE_POLICY_NAME: name of the IAM policy
  
6. Create the outputs.tf file with the following outputs:
  - kke_dynamodb_table: name of the DynamoDB table
  - kke_iam_role_name: name of the IAM role
  - kke_iam_policy_name: name of the IAM policy
  
7. Define the actual values for these variables in the terraform.tfvars file.

8. Ensure that the IAM policy allows only read access and restricts it to the specific DynamoDB table created.

## The Solution

Because we're going to use them in the main.tf, create the ```variables.tf``` file first. Infact, this whole task starts with tasks 5 and 7 so read the whole thing before to start or you'll be going in circles. 

Inside the variables file, create the 3 required variables but leave their contents empty. The value will be provided in the .tfvars file. 
```
variable "KKE_TABLE_NAME" {}

variable "KKE_ROLE_NAME" {}

variable "KKE_POLICY_NAME" {}
```

Now, as mentioned a moment ago, create the ```terraform.tfvars``` file
```
KKE_TABLE_NAME = "xfusion-table"

KKE_ROLE_NAME = "xfusion-role"

KKE_POLICY_NAME = "xfusion-readonly-policy"
```

Now we can create ```main.tf```
```
resource "aws_dynamodb_table" "xfusion_table" {
  name = var.KKE_TABLE_NAME
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "id"
  attribute {
    name = "id"
    type = "S"
  }
  tags = {
    Name = var.KKE_TABLE_NAME
  }
}

resource "aws_iam_role" "xfusion_role" {
  name = var.KKE_ROLE_NAME
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principle = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy" "xfusion_readonly_policy" {
  name = var.KKE_POLICY_NAME
  description = "Read-Only access to xfusion-table"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:Scan",
          "dynamodb:Query"
        ]
        Resource = aws_dynamodb_table.xfusion_table.arn
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "xfusion_attach" {
  role = aws_iam_role.xfusion_role.name
  policy_arn = aws_iam_policy.xfusion_readonly_policy.arn
}
```

Then we can create the ```outputs.tf``` file which will look something like this
```
output "kke_dynamodb_table" {
  value = aws_dynamodb_table.xfusion_table.name
}

output "kke_iam_role_name" {
  value = aws_iam_role.xfusion_role.name
}

output "kke_iam_policy_name" {
  value = aws_iam_policy.xfusion_readonly_policy.name
}
```

And now we're ready to run the big three. Remember to check the output and troubleshoot along the way. These Terraform files are getting big now, the chances of you making a mistake increases.
```
terraform init
terraform plan
terraform apply
```

You can then verify by checking the state file with ```terraform state list``` and show the full deployment with ```terraform show```

## Thoughts and takeaways
Thats was brutal. Did not go the way I hoped at all. Took ages and many an error were hit. I get the purpose of IaC but I feel like if the build isnt something that will ever need repeating, it may not actually be a time saver at all. I somewhat feel that this task for instacnce would have been a 5 min job in the console. If however, you want the option of having the deployment ready to push again at a moment notice, of course its a time saver in the long run. But yeah, that one took me about 40 minutes so... Not the fastest means of deployment. Time for tea. 





