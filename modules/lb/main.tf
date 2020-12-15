resource "aws_lb" "lb" {
  name               = "vertica-nodes-lb"
  load_balancer_type = "network"
  subnets            = [var.subnet_id]
}

resource "aws_lb_target_group" "db_group" {
  name     = "vertica-db-target-group"
  port     = 5433
  protocol = "TCP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_target_group" "ssh_group" {
  name     = "vertica-ssh-target-group"
  port     = 22
  protocol = "TCP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_target_group_attachment" "db_attachments" {
  count = length(var.node_ids)

  target_group_arn = aws_lb_target_group.db_group.arn
  target_id        = var.node_ids[count.index]
  port             = 5433
}

resource "aws_lb_target_group_attachment" "ssh_attachments" {
  target_group_arn = aws_lb_target_group.ssh_group.arn
  target_id        = var.node_ids[0]
  port             = 22
}

resource "aws_lb_listener" "db_listener" {
  load_balancer_arn = aws_lb.lb.arn
  port              = 5433
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.db_group.arn
  }
}

resource "aws_lb_listener" "ssh_listener" {
  load_balancer_arn = aws_lb.lb.arn
  port              = 22
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ssh_group.arn
  }
}
