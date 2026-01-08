## The Problem


## The Solution

```
variabes.tf
```

```
variable "KKK_VPC_CIDR" {
  default = "10.0.0.0/16"

variable "KKK_SUBNET_CIDR" {
  default = "10.0.1.0/24"
}
```

```
main.tf
```

```
resource "aws_vpc" "devops_vpc" {
  cidr_block = var.KKK_VPC_CIDR
  tags = {
    Name = "devops-priv-vpc"
  }
}

resource "aws_subnet" "devops_subnet" {
  vpc_id = aws_vpc.devops_vpc.id
  cidr_block = var.KKK_SUBNET_CIDR
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
    cidr_blocks = [var.KKK_VPC_CIDR]
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

```
outputs.tf
```

```
output "KKK_vpc_name" {
  value = aws_vpc.devops_vpc.tags["Name"]
}

output "KKK_subnet_name" {
  value = aws_subnet.devops_subnet.tags["Name"]
}

output "KKK_ec2_private" {
  value = aws_instance.devops_ec2.tags["Name"]
}
```


```
terraform init
terraform plan
terraform apply
```


```
terraform show
terraform state list
```



