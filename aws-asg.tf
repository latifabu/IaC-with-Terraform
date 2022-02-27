resource "aws_launch_configuration" "latif" {
  name_prefix     = "tf-asg-latif-lc-"
  image_id        = "ami-0765af24323e4f33c"
  instance_type   = "t2.micro"
  security_groups = ["sg-0d3c30c4549c21cf1"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "latif" {
  min_size             = 1
  max_size             = 3
  desired_capacity     = 1
  launch_configuration = aws_launch_configuration.latif.name
  vpc_zone_identifier  = ["subnet-0e1ee83a65ccbe21f"]
}

resource "aws_lb" "latif" {
  name               = "latif-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["sg-0d3c30c4549c21cf1"]
  subnets            = ["subnet-0e1ee83a65ccbe21f", "subnet-0ee240174c8af9b3b"]
}
# set up an application load balancer listener to hear requests at port 80
resource "aws_lb_listener" "latif" {
  load_balancer_arn = aws_lb.latif.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.latif.arn
  }
}
# set up the target group to direct load balancer traffic to port 80
resource "aws_lb_target_group" "latif" {
  name     = "latif-tf-asg-practice"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "vpc-0fe6bec6cd2cf53ec"
}

resource "aws_autoscaling_attachment" "latif" {
  autoscaling_group_name = aws_autoscaling_group.latif.id
  alb_target_group_arn   = "${aws_lb_target_group.latif.arn}"
}

resource "aws_autoscaling_policy" "latif_scale_up" {
  name                   = "latif-scale-up"
  autoscaling_group_name = aws_autoscaling_group.latif.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1
  cooldown               = 300
}

resource "aws_autoscaling_policy" "latif_scale_down" {
  name                   = "latif-scale-down"
  autoscaling_group_name = aws_autoscaling_group.latif.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
  cooldown               = 300

}
# define cloudwatch monitoring
resource "aws_cloudwatch_metric_alarm" "latif_scale_up_alarm" {
  alarm_description   = "Monitors CPU utilization for app"
  alarm_actions       = [aws_autoscaling_policy.latif_scale_up.arn]
  alarm_name          = "latif_scale_up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  threshold           = "30"
  evaluation_periods  = "1"
  period              = "120"
  statistic           = "Average"
  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.latif.name}"
  }

}

resource "aws_cloudwatch_metric_alarm" "latif_scale_down_alarm" {
  alarm_description   = "Monitors CPU utilization for app"
  alarm_actions       = [aws_autoscaling_policy.latif_scale_down.arn]
  alarm_name          = "latif_scale_down"
  comparison_operator = "LessThanOrEqualToThreshold"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  threshold           = "10"
  evaluation_periods  = "1"
  period              = "120"
  statistic           = "Average"

  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.latif.name}"
  }
}
