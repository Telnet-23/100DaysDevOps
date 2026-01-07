## The Problem
The Nautilus DevOps team is strategizing the migration of a portion of their infrastructure to the AWS cloud. Recognizing the scale of this undertaking, they have opted to approach the migration in incremental steps rather than as a single massive transition. To achieve this, they have segmented large tasks into smaller, more manageable units. This granular approach enables the team to execute the migration in gradual phases, ensuring smoother implementation and minimizing disruption to ongoing operations. By breaking down the migration into smaller tasks, the Nautilus DevOps team can systematically progress through each stage, allowing for better control, risk mitigation, and optimization of resources throughout the migration process.

Use Terraform to create a security group under the default VPC with the following requirements:

1. The name of the security group must be nautilus-sg.

2. The description must be Security group for Nautilus App Servers.

3. Add an inbound rule of type HTTP, with a port range of 80, and source CIDR range 0.0.0.0/0.
   
4. Add another inbound rule of type SSH, with a port range of 22, and source CIDR range 0.0.0.0/0.

Ensure that the security group is created in the us-east-1 region using Terraform. The Terraform working directory is /home/bob/terraform. Create the main.tf file (do not create a different .tf file) to accomplish this task.


## The Solution
I feel at a bit of a handicap with these Terrform challenges as I'm also trying to learn some AWS with it coming from a complete Azure backgroup. I did use a guide to help me with this challenge. So first, I made a variables file called ```variables.tf``` that looked like this:

```
variable "sg_name" {
  default = "nautilus-sg"
}

variable "sg_description" {
  default = "Security group for Nautilus App Servers"
}
```
Then, I made ```main.tf``` which looked like this
```
data "aws_vpc" "default_vpc" {
  default = true
}

resource "aws_security_group" "nautilus-sg" {
  name = var.sg_name
  description = var.sg_description
  vpc_id = data.aws_vpc.default_vpc.id

 ingress {
    description = "HTTP"
    from_port = 80
    to_port = 80

    protocol = "tcp"
    cidr_block = ["0.0.0.0/0"]
 }

 ingress {
    description = "SSH"
    from_port = 22
    to_port = 22

    protocol = "tcp"
    cidr_block = ["0.0.0.0/0"]
 }
}
```
Then initialise Terraform with 
```
terraform init
```

Providing the initialisation was successsful, view what changes will be made
```
terraform plan
```
Then apply the changes
```
terraform apply
```

And type ```yes``` when promted.

You can then view the state with
```
terraform state list
```

