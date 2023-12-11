locals {
  tags = merge(var.tags, {tf-module-name = "alb"},{env=var.env})
  sg_name = var.internal ? "${var.env}-alb-internal-lb" : "${var.env}-alb-public-sg"        #no need of this
  lb_name = var.internal ? "${var.env}-alb-internal" : "${var.env}-alb-public"

}
