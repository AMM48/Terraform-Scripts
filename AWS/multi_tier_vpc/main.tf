
module "vpc" {
  source = "./modules/network/vpc"
}

module "elb" {
  source       = "./modules/compute/elb"
  vpc-id       = module.vpc.vpc-id
  subnets      = module.vpc.subnets
  web-alb-sg   = module.vpc.web-alb-sg
  app-alb-sg   = module.vpc.app-alb-sg
  acm-cert-arn = module.route53.acm-cert-arn
}

module "route53" {
  source           = "./modules/network/route53"
  domain_name      = var.domain_name
  web-alb-dns-name = module.elb.web-alb-dns-name
  web-alb-zone-id  = module.elb.web-alb-zone-id
  app-alb-dns-name = module.elb.app-alb-dns-name
  app-alb-zone-id  = module.elb.app-alb-zone-id
  dns-zone-id      = module.route53.dns-zone-id
}

module "rds" {
  source      = "./modules/storage/rds"
  subnets     = module.vpc.subnets
  db-sg       = module.vpc.db-sg
  db_name     = var.db_name
  db_username = var.db_username
  db_password = var.db_password
}

module "asg" {
  source               = "./modules/compute/asg"
  subnets              = module.vpc.subnets
  web-sg               = module.vpc.web-sg
  app-sg               = module.vpc.app-sg
  web-tg-arn           = module.elb.web-tg-arn
  app-tg-arn           = module.elb.app-tg-arn
  domain_name          = var.domain_name
  instance_profile_arn = module.roles.instance_profile_arn
  depends_on           = [module.ssm]
}

module "roles" {
  source = "./modules/identity/roles"
}

module "ssm" {
  source           = "./modules/security/ssm"
  db_endpoint      = module.rds.endpoint
  db_read_endpoint = module.rds.reader_endpoint
  db_name          = var.db_name
  db_username      = var.db_username
  db_password      = var.db_password
}

module "cloudwatch" {
  source                   = "./modules/monitor/cloudwatch"
  web_asg_name             = module.asg.web-asg-name
  app_asg_name             = module.asg.app-asg-name
  web_scale_policy_out_arn = module.asg.web-scale-policy-out-arn
  app_scale_policy_out_arn = module.asg.app-scale-policy-out-arn
  web_scale_policy_in_arn  = module.asg.web-scale-policy-in-arn
  app_scale_policy_in_arn  = module.asg.app-scale-policy-in-arn
}
