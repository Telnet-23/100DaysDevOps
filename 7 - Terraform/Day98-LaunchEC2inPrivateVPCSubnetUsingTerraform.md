## The Problem
The Nautilus DevOps team is expanding their AWS infrastructure and requires the setup of a private Virtual Private Cloud (VPC) along with a subnet. This VPC and subnet configuration will ensure that resources deployed within them remain isolated from external networks and can only communicate within the VPC. Additionally, the team needs to provision an EC2 instance under the newly created private VPC. This instance should be accessible only from within the VPC, allowing for secure communication and resource management within the AWS environment.

1. Create a VPC named devops-priv-vpc with the CIDR block 10.0.0.0/16.

2. Create a subnet named devops-priv-subnet inside the VPC with the CIDR block 10.0.1.0/24 and auto-assign IP option must not be enabled.

3. Create an EC2 instance named devops-priv-ec2 inside the subnet and instance type must be t2.micro.

4. Ensure the security group of the EC2 instance allows access only from within the VPC's CIDR block.

5. Create the main.tf file (do not create a separate .tf file) to provision the VPC, subnet and EC2 instance.

6. Use variables.tf file with the following variable names:
  - KKE_VPC_CIDR for the VPC CIDR block.
  - KKE_SUBNET_CIDR for the subnet CIDR block.
  
7. Use the outputs.tf file with the following variable names:
  - KKE_vpc_name for the name of the VPC.
  - KKE_subnet_name for the name of the subnet.
  - KKE_ec2_private for the name of the EC2 instance.

## The Solution
As the variables will be called upon in the main.tf file, I'll make ```variabes.tf``` first. Its contents should look like this
```
variable "KKE_VPC_CIDR" {
  default = "10.0.0.0/16"
}

variable "KKE_SUBNET_CIDR" {
  default = "10.0.1.0/24"
}
```
After thats done, create ```main.tf```. Mine looked like this and be aware, I made a lot of mistakes before this finally worked. 
```
resource "aws_vpc" "devops_vpc" {
  cidr_block = var.KKE_VPC_CIDR
  tags = {
    Name = "devops-priv-vpc"
  }
}

resource "aws_subnet" "devops_subnet" {
  vpc_id = aws_vpc.devops_vpc.id
  cidr_block = var.KKE_SUBNET_CIDR
  map_public_ip_on_launch = false
  tags = {
    Name = "devops-priv-subnet"
  }
}

resource "aws_security_group" "devops_sg" {
  name = "devops_priv_sg"
  description = "allow traffic from VPC CIDR only"
  vpc_id = aws_vpc.devops_vpc.id
  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [var.KKE_VPC_CIDR]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "latest_amazon_linux" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "devops_ec2" {
  ami = data.aws_ami.latest_amazon_linux.id
  instance_type = "t2.micro"
  subnet_id = aws_subnet.devops_subnet.id
  vpc_security_group_ids = [aws_security_group.devops_sg.id]
  tags = {
    Name = "devops-priv-ec2"
  }
}
```
And then finally, create the ```outputs.tf``` file.
```
output "KKE_vpc_name" {
  value = aws_vpc.devops_vpc.tags["Name"]
}

output "KKE_subnet_name" {
  value = aws_subnet.devops_subnet.tags["Name"]
}

output "KKE_ec2_private" {
  value = aws_instance.devops_ec2.tags["Name"]
}
```

Run the holy trinity and troubleshoot along the way. You almost certianly made an error or 2 or misplaces a { 
```
terraform init
terraform plan
terraform apply
```


```
terraform show
terraform state list
```

## Thoughts and takeaways
I failed this one a couple of times. One time for the stupidest reason (I called the variable file variable.tf and not variables.tf). Its all learning. I was told Terraform was easy but so far, I'm not seeing it :smile: Again it may also be my lack of aws knowledge and practice working against me here. I'm trying to automate deployments for things I've never manually deployed. Still fun though and I'll be looking to work it into more Azure based projects and eventually, when I start picking up some AWS, At least I'll know some Terraform. Time for tea. 

