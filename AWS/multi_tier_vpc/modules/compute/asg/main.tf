resource "aws_launch_template" "web-lt" {
  name_prefix            = "web-lt"
  description            = "Web Launch Template"
  instance_type          = "t2.micro"
  image_id               = "ami-0e731c8a588258d0d"
  vpc_security_group_ids = var.web-sg
  user_data = base64encode(<<-EOF
  #!/bin/bash
  dnf update -y
  dnf install -y docker
  systemctl start docker
  docker pull wajeeh8/bookmark-app:clientlatest
  docker run -d -p 80:3000 wajeeh8/bookmark-app:clientlatest
  CONTAINER_ID=$(docker ps -q)
  docker exec $CONTAINER_ID sed -i 's/endpoint/https:\/\/api.${var.domain_name[1]}/g' /app/src/components/custom_hooks/useFetch.jsx
  docker exec $CONTAINER_ID sed -i 's/endpoint/https:\/\/api.${var.domain_name[1]}/g' /app/src/components/custom_hooks/useAdd.jsx
  docker exec $CONTAINER_ID sed -i 's/endpoint/https:\/\/api.${var.domain_name[1]}/g' /app/src/components/custom_hooks/useDelete.jsx
  docker exec $CONTAINER_ID sed -i 's/endpoint/https:\/\/api.${var.domain_name[1]}/g' /app/src/components/custom_hooks/useUpdate.jsx


  EOF
  )
}

resource "aws_autoscaling_group" "web-asg" {
  min_size                  = 3
  desired_capacity          = 3
  max_size                  = 9
  vpc_zone_identifier       = [for subnet in var.subnets : subnet.id if contains(["sn-web-a", "sn-web-b", "sn-web-c"], subnet.tags["Name"])]
  health_check_type         = "ELB"
  health_check_grace_period = 300
  target_group_arns         = var.web-tg-arn
  launch_template {
    id      = aws_launch_template.web-lt.id
    version = "$Latest"
  }
}

resource "aws_launch_template" "app-lt" {
  name_prefix            = "app-lt"
  description            = "App Launch Template"
  instance_type          = "t2.micro"
  image_id               = "ami-0e731c8a588258d0d"
  vpc_security_group_ids = var.app-sg

  iam_instance_profile {
    arn = var.instance_profile_arn
  }

  user_data = base64encode(<<-EOF
  #!/bin/bash
  dnf update -y
  dnf install -y docker
  dnf install -y mariadb105-server
  systemctl start docker
  systemctl start mariadb
  docker pull wajeeh8/bookmark-app:serverlatest
  docker run -d -p 80:80 wajeeh8/bookmark-app:serverlatest
  ENDPOINT=$(aws ssm get-parameters --region us-east-1 --names /dbEndpoint --query Parameters[0].Value)
  ENDPOINT=$${ENDPOINT//\"}
  READ_ENDPOINT=$(aws ssm get-parameters --region us-east-1 --names /dbReadEndpoint --query Parameters[0].Value)
  READ_ENDPOINT=$${READ_ENDPOINT//\"}
  DB_NAME=$(aws ssm get-parameters --region us-east-1 --names /dbName --query Parameters[0].Value)
  DB_NAME=$${DB_NAME//\"}
  DB_USERNAME=$(aws ssm get-parameters --region us-east-1 --names /dbUsername --query Parameters[0].Value)
  DB_USERNAME=$${DB_USERNAME//\"}
  DB_PASSWORD=$(aws ssm get-parameters --region us-east-1 --names /dbPassword --with-decryption --query Parameters[0].Value)
  DB_PASSWORD=$${DB_PASSWORD//\"}
  CONTAINER_ID=$(docker ps -q)
  docker exec $CONTAINER_ID sed -i "s/writeEndpoint/$ENDPOINT/g" /var/www/db/Database.php
  docker exec $CONTAINER_ID sed -i "s/readEndpoint/$READ_ENDPOINT/g" /var/www/db/Database.php
  docker exec $CONTAINER_ID sed -i "s/dbName/$DB_NAME/g" /var/www/db/Database.php
  docker exec $CONTAINER_ID sed -i "s/dbUsername/$DB_USERNAME/g" /var/www/db/Database.php
  docker exec $CONTAINER_ID sed -i "s/dbPassword/$DB_PASSWORD/g" /var/www/db/Database.php

  echo "USE bookmarking_db;
  CREATE TABLE bookmarks(
  id MEDIUMINT NOT NULL AUTO_INCREMENT,
  title VARCHAR(255) NOT NULL,
  link VARCHAR(255) NOT NULL,
  date_added DATETIME NOT NULL,
  PRIMARY KEY (id)
  );
  INSERT INTO bookmarks(title, link, date_added) VALUES ('React.js', 'https://react.dev', NOW());
  INSERT INTO bookmarks(title, link, date_added) VALUES ('Docker', 'https://docker.com', NOW());
  INSERT INTO bookmarks(title, link, date_added) VALUES ('GitHub', 'https://github.com', NOW());" > db.sql

  mysql -h $ENDPOINT -u $DB_USERNAME -p$DB_PASSWORD $DB_NAME < db.sql


  EOF
  )
}

resource "aws_autoscaling_group" "app-asg" {
  min_size                  = 3
  desired_capacity          = 3
  max_size                  = 7
  vpc_zone_identifier       = [for subnet in var.subnets : subnet.id if contains(["sn-app-a", "sn-app-b", "sn-app-c"], subnet.tags["Name"])]
  health_check_type         = "ELB"
  health_check_grace_period = 300
  target_group_arns         = var.app-tg-arn
  launch_template {
    id      = aws_launch_template.app-lt.id
    version = "$Latest"
  }
}

resource "aws_autoscaling_policy" "web_scale_policy_out" {
  name                   = "web_scale_out"
  autoscaling_group_name = aws_autoscaling_group.web-asg.name
  adjustment_type        = "ChangeInCapacity"
  policy_type            = "StepScaling"

  step_adjustment {
    metric_interval_lower_bound = 0
    metric_interval_upper_bound = 10
    scaling_adjustment          = 1
  }

  step_adjustment {
    metric_interval_lower_bound = 10
    metric_interval_upper_bound = 20
    scaling_adjustment          = 1
  }

  step_adjustment {
    metric_interval_lower_bound = 20
    metric_interval_upper_bound = 30
    scaling_adjustment          = 3
  }

  step_adjustment {
    metric_interval_lower_bound = 30
    scaling_adjustment          = 6
  }
}

resource "aws_autoscaling_policy" "web_scale_policy_in" {
  name                   = "web_scale_in"
  autoscaling_group_name = aws_autoscaling_group.web-asg.name
  adjustment_type        = "ChangeInCapacity"
  policy_type            = "StepScaling"

  step_adjustment {
    metric_interval_lower_bound = -10
    metric_interval_upper_bound = 0
    scaling_adjustment          = -1
  }

  step_adjustment {
    metric_interval_lower_bound = -20
    metric_interval_upper_bound = -10
    scaling_adjustment          = -3
  }
  step_adjustment {
    metric_interval_upper_bound = -20
    scaling_adjustment          = -6
  }
}

resource "aws_autoscaling_policy" "app_scale_policy_out" {
  name                   = "app_scale_out"
  autoscaling_group_name = aws_autoscaling_group.app-asg.name
  adjustment_type        = "ChangeInCapacity"
  policy_type            = "StepScaling"

  step_adjustment {
    metric_interval_lower_bound = 0
    metric_interval_upper_bound = 10
    scaling_adjustment          = 1
  }

  step_adjustment {
    metric_interval_lower_bound = 10
    metric_interval_upper_bound = 20
    scaling_adjustment          = 1
  }

  step_adjustment {
    metric_interval_lower_bound = 20
    metric_interval_upper_bound = 30
    scaling_adjustment          = 1
  }

  step_adjustment {
    metric_interval_lower_bound = 30
    scaling_adjustment          = 4
  }
}

resource "aws_autoscaling_policy" "app_scale_policy_in" {
  name                   = "app_scale_in"
  autoscaling_group_name = aws_autoscaling_group.app-asg.name
  adjustment_type        = "ChangeInCapacity"
  policy_type            = "StepScaling"

  step_adjustment {
    metric_interval_lower_bound = -10
    metric_interval_upper_bound = 0
    scaling_adjustment          = -1
  }

  step_adjustment {
    metric_interval_lower_bound = -20
    metric_interval_upper_bound = -10
    scaling_adjustment          = -2
  }
  step_adjustment {
    metric_interval_upper_bound = -20
    scaling_adjustment          = -4
  }
}
