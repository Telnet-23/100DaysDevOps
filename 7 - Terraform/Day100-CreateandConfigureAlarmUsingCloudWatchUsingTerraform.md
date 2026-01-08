## The Problem
The Nautilus DevOps team has been tasked with setting up an EC2 instance for their application. To ensure the application performs optimally, they also need to create a CloudWatch alarm to monitor the instance's CPU utilization. The alarm should trigger if the CPU utilization exceeds 90% for one consecutive 5-minute period. To send notifications, use the SNS topic named nautilus-sns-topic, which is already created.

1. Launch EC2 Instance: Create an EC2 instance named nautilus-ec2 using any appropriate Ubuntu AMI (you can use AMI ami-0c02fb55956c7d316).

2. Create CloudWatch Alarm: Create a CloudWatch alarm named nautilus-alarm with the following specifications:
  - Statistic: Average
  - Metric: CPU Utilization
  - Threshold: >= 90% for 1 consecutive 5-minute period
  - Alarm Actions: Send a notification to the nautilus-sns-topic SNS topic.
    
3. Update the main.tf file (do not create a separate .tf file) to create a EC2 Instance and CloudWatch Alarm.

4. Create an outputs.tf file to output the following values:
  - KKE_instance_name for the EC2 instance name.
  - KKE_alarm_name for the CloudWatch alarm name.

## The Solution
In this task, the ```main.tf``` file already exisits, you just need to update it. So open it up and append the following:
```
resource "aws_instance" "nautilus_node" {
  ami = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"
  tags = {
    Name = "nautilus-ec2"
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_alert" {
  alarm_name = "nautilus-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "1"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "300"
  statistic = "Average"
  threshold = "90"
  alarm_description = "Alarm when CPU exceeds 90%"
  alarm_actions = [aws_sns_topic.sns_topic.arn]
  dimensions = {
    InstanceId = aws_instance.nautilus_node.id
  }
}
```
Once that is edited, create the ```outputs.tf``` file as requested
```
output "KKE_instance_name" {
  value = aws_instance.nautilus_node.tags.Name
}

output "KKE_alarm_name" {
  value = aws_cloudwatch_metric_alarm.cpu_alert.alarm_name
}
```

And for one last time, lets run the big three and troubleshoot the errors along the way
```
terraform init
terraform plan
terraform apply
```

You can verify your work with ```terraform state list``` and ```terraform show```

## Thoughts and takeaways
That felt slightly easier. Nice to know monitoring can also be automated and again, you're just declaring exactly what to monitor and the alert triggers. Nice and simple. Well! day 100 done. Its been emotional. For one last time.... Time for tea. 
