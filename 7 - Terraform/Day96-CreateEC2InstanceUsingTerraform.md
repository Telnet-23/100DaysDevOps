## The Problem


## The Solution

```
main.tf
```

```
resource "tls_private_key" "my_key" {
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "aws_key_pair" "developer" {
  key_name = ""
  public_key = tls_private_key.my_key.public_key_openssh
}

data "aws_instance" "web" {
  name = "default"
}

resource "aws_instance" "web" {
  ami = "ami-0c101f26f147fa7fd"
  instance_type = "t2.micro"

  key_name = aws_key_pair.developer.key_name

  vpc_security_group_ids = [data.aws_security_group.default_sg.id]

  tags = {
    Name = ""
  }
}
```
  
