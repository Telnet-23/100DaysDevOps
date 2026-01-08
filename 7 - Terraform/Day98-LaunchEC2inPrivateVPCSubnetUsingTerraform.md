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
```



