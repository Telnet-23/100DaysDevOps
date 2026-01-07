## The Problem
The Nautilus DevOps team is strategizing the migration of a portion of their infrastructure to the AWS cloud. Recognizing the scale of this undertaking, they have opted to approach the migration in incremental steps rather than as a single massive transition. To achieve this, they have segmented large tasks into smaller, more manageable units.

For this task, create an EC2 instance using Terraform with the following requirements:

1. The EC2 instance must use the value xfusion-ec2 as its Name tag, which defines the instance name in AWS.

2. Use the Amazon Linux ami-0c101f26f147fa7fd to launch this instance.

3. The Instance type must be t2.micro.

4. Create a new RSA key named xfusion-kp.

5. Attach the default (available by default) security group.

The Terraform working directory is /home/bob/terraform. Create the main.tf file (do not create a different .tf file) to provision the instance.

## The Solution
Create the main.tf file first of all
```
main.tf
```
Add the required entries to it, mine looked like this 
```
resource "tls_private_key" "my_key" {
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "aws_key_pair" "deployer" {
  key_name = "xfusion-kp"
  public_key = tls_private_key.my_key.public_key_openssh
}

data "aws_security_group" "default_sg" {
  name = "default"
}

resource "aws_instance" "web" {
  ami = "ami-0c101f26f147fa7fd"
  instance_type = "t2.micro"

  key_name = aws_key_pair.deployer.key_name

  vpc_security_group_ids = [data.aws_security_group.default_sg.id]

  tags = {
    Name = "xfusion-ec2"
  }
}
```

Run the big three 
```
terraform init
terraform plan
terraform apply
```

And make sure your config is pushed issue free. 

## Thoughts and takeaways
I'm getting the jist of it. It doesnt seem difficult really. You kind of just declare exactly what you want. I'm not a massive fan of the syntax and vscode is doing a lot of intellisense but I think with a few weeks solid practice with Terraform, I could get the hang of it quite fast. Time for tea. 
  
