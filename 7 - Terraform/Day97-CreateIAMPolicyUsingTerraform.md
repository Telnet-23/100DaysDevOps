## The Problem
When establishing infrastructure on the AWS cloud, Identity and Access Management (IAM) is among the first and most critical services to configure. IAM facilitates the creation and management of user accounts, groups, roles, policies, and other access controls. The Nautilus DevOps team is currently in the process of configuring these resources and has outlined the following requirements.

Create an IAM policy named iampolicy_siva in us-east-1 region using Terraform. It must allow read-only access to the EC2 console, i.e., this policy must allow users to view all instances, AMIs, and snapshots in the Amazon EC2 console.

The Terraform working directory is /home/bob/terraform. Create the main.tf file (do not create a different .tf file) to accomplish this task.

## The Solution

```
main.tf
```
Then build your config. Mine looked like this
```
resource "aws_iam_policy" "policy_siva" {
    name = "iampolicy_siva"
    description = "allows read-only access to the EC2 console"
    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = [
                    "ec2:Describe*",
                ]
                Effect = "Allow"
                Resource = "*"
            }
        ]
    })
}
```
Run the famous three and troubleshoot along the way. I had loads of errors doing this task when trying to initialise. 
```
terraforn init
terraform plan
terraform apply
```

## Thoughts and takeaways
What I'm really finding hard about this is the AWS stuff. I dont understand/use AWS so knowing what is required for resources and the terminaology is a bit of a curve ball for me. Theres no resource groups or anything to pile all associated resources to gether like in Azure. Permissions dont seem as clearly named as they are in Azure either as I found doing this challenge. 
Anyway. Tea time. That was tough. 
