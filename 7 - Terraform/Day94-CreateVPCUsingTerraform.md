## The Problem
The Nautilus DevOps team is strategizing the migration of a portion of their infrastructure to the AWS cloud. Recognizing the scale of this undertaking, they have opted to approach the migration in incremental steps rather than as a single massive transition. To achieve this, they have segmented large tasks into smaller, more manageable units. This granular approach enables the team to execute the migration in gradual phases, ensuring smoother implementation and minimizing disruption to ongoing operations. By breaking down the migration into smaller tasks, the Nautilus DevOps team can systematically progress through each stage, allowing for better control, risk mitigation, and optimization of resources throughout the migration process.

Create a VPC named nautilus-vpc in region us-east-1 with any IPv4 CIDR block through terraform.

The Terraform working directory is /home/bob/terraform. Create the main.tf file (do not create a different .tf file) to accomplish this task.

## The Solution
First of all, create a new file called main.tf in the vscode window that is open. Along side that, right click that left hand pane and opena bash shell (open an intergrated terminal). run ```pwd``` to make sure you're in the right place. 

build your main.tf file to look like this. Note that you do not need to state the provider as there is a 'provider.tf' file already in the directory. Terraform reads all .tf files at once so if you state the provider in the main.tf file too, it will error. Make sure the location in 'provider.tf' is set correctly for the challenge. 
```
resource "aws_vpc" "main" {
  cidr_block = "10.10.0.0/16"

  tags = {
    Name = "nautilus-vpc"
  }
}
```

Once that's done, initialise Terraform. If there are any issues (such as the provider being sttaed i nthe main.tf), this is when you'll find out. You should see ```Terraform has been successfully initialized!```
```
terraform init
```

Then view the changes that are goinf to take place. It will state that 'aws_vpc.main will be created'
```
terraform plan
```
Then finally, apply the config uration change and confirm it by typing 'yes' when prompted. 
```
terraform apply
```

## Thoughts and takeaways
Well all know Terraform is ace. Thats no secret. I will say I have very little experience in AWS however as as all the Terraform challenges are in AWS, it should prove quite a challenge as I also try to work out what I'm actually creating with AWS terminology instead of Azure. Pretty sure a VPC is the equivilent of a VNET? Seems to be. Anyway, tea time. 
