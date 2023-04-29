
data "aws_iam_instance_profile" "EC2-attach" {
  name = "attaching-role-to-ec2"
}


resource "aws_security_group" "ec2_access" {
  name   = "project-sg"
  vpc_id = var.vpc-id
  
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}


resource "aws_security_group_rule" "ingress_ec2_traffic" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = aws_security_group.ec2_access.id
  source_security_group_id = aws_security_group.lb.id
}


resource "aws_launch_template" "aws_autoscale_conf" {
  name            = "web_config"
  image_id        = var.instance-ami
  vpc_security_group_ids = ["${aws_security_group.ec2_access.id}"]
  instance_type   = var.instance_type
  key_name        = var.pem-key
  iam_instance_profile {
    name = data.aws_iam_instance_profile.EC2-attach.name
  }
  user_data = base64encode(
    <<EOF
#!/bin/bash
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl
sudo apt-get update
sudo apt install awscli -y
sudo apt-get install -y docker.io
sudo docker login -u AWS -p $(aws ecr get-login-password --region ap-south-1) $(aws sts get-caller-identity --query "Account" --output text).dkr.ecr.ap-south-1.amazonaws.com
sudo docker pull $(aws sts get-caller-identity --query "Account" --output text).dkr.ecr.ap-south-1.amazonaws.com/flask-app-image:$IMAGE_TAG
sudo docker run -d -p 8080:5000 --name my_app $(aws sts get-caller-identity --query "Account" --output text).dkr.ecr.ap-south-1.amazonaws.com/flask-app-image:$IMAGE_TAG
    EOF
  )
  lifecycle {
    
    create_before_destroy = true
  }
}


resource "aws_autoscaling_group" "mygroup" {
  name                 = "autoscalegroup"
  max_size             = 4
  min_size             = 1
  desired_capacity     = 2
  health_check_type    = "EC2"
  depends_on           = [aws_lb.my_elb]
  vpc_zone_identifier  = [var.pr-subnet-id-1,var.pr-subnet-id-2]
  target_group_arns    = ["${aws_lb_target_group.TG-01.arn}"]
  termination_policies      = ["OldestInstance"]
  launch_template {
    id      = aws_launch_template.aws_autoscale_conf.id
    version = aws_launch_template.aws_autoscale_conf.latest_version
  }
   instance_refresh {
    strategy = "Rolling"
    
  }
}

resource "aws_autoscaling_policy" "instance_up" {
  name = "instance-up-policy"
  scaling_adjustment = 1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = aws_autoscaling_group.mygroup.name
}

resource "aws_cloudwatch_metric_alarm" "instance_up_cpu_alarm" {
  alarm_name                = "instance_up_cpu_alarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 2
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = 120
  statistic                 = "Minimum"
  threshold                 = 80
  alarm_description         = "This metric monitors ec2 cpu utilization"
  alarm_actions = [aws_autoscaling_policy.instance_up.arn]
}

resource "aws_autoscaling_policy" "instance_down" {
  name = "instance-down-policy"
  scaling_adjustment = 1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = aws_autoscaling_group.mygroup.name
}

resource "aws_cloudwatch_metric_alarm" "instance_down_cpu_alarm" {
  alarm_name                = "instance_down_cpu_alarm"
  comparison_operator       = "LessThanOrEqualToThreshold"
  evaluation_periods        = 2
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = 120
  statistic                 = "Minimum"
  threshold                 = 20
  alarm_description         = "This metric monitors ec2 cpu utilization"
  alarm_actions = [aws_autoscaling_policy.instance_down.arn]
}


resource "aws_lb_target_group" "TG-01" {
  name       = "LB-TargetGroup"
  depends_on = [var.vpc-id]
  port       = 8080
  protocol   = "HTTP"
  vpc_id     = var.vpc-id
  health_check {
    interval            = 70
    port                = 8080
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 60
    protocol            = "HTTP"
    matcher             = "200,202"
  }
}
resource "aws_security_group" "lb" {
  name   = "lb-sg"
  vpc_id = var.vpc-id
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group_rule" "egress_alb_traffic" {
  type                     = "egress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = aws_security_group.lb.id
  source_security_group_id = aws_security_group.ec2_access.id
}


resource "aws_lb" "my_elb" {
  name               = "asg-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.lb.id}"]
  subnets            = [var.pub-subnet-id-1, var.pub-subnet-id-2]

}

resource "aws_lb_listener" "frontend" {
  load_balancer_arn = aws_lb.my_elb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.TG-01.arn
  }
}


