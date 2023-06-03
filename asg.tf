resource "aws_launch_template" "webserver_launch_template" {

  name                    = "webserver-launch-template"
  image_id                = "ami-0c6a3e1a3670c46eb"
  instance_type           = "t2.micro"
  key_name                = "mykeypair"
  vpc_security_group_ids = [aws_security_group.webserver_security_group.id]

}

resource "aws_autoscaling_group" "asg" {
  vpc_zone_identifier = [aws_subnet.private_app_subnet_az1.id,
  aws_subnet.private_app_subnet_az2.id]
  name                      = "safo auto scaling group"
  max_size                  = 5
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 4
 
  launch_template {
    id      = aws_launch_template.webserver_launch_template.id
    version = "$Latest"
  }

    tag {
        key = "Name"
        value = "asg-webserver"
        propagate_at_launch = true
    }

    lifecycle {
        ignore_changes = [target_group_arns]
    }
}

resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.asg.name
  lb_target_group_arn   = aws_lb_target_group.alb_target_group.arn
}


resource "aws_autoscaling_notification" "webserver_notifications" {
  group_names = [aws_autoscaling_group.asg.name]

  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
  ]

  topic_arn = aws_sns_topic.safo_updates.arn
}
 