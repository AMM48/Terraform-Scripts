module "api_gateway" {
  source          = "./modules/integration/api_gateway"
  api_role        = module.roles.api_role_arn
  domain_name     = var.domain_name
  certificate_arn = module.route53.certificate_arn
}

module "route53" {
  source              = "./modules/network/route53"
  domain_name         = var.domain_name
  api_dns_name        = module.api_gateway.api_dns_name
  api_zone_id         = module.api_gateway.api_gateway_regional_id_zone
  cloudfront_dns_name = module.cloudfront.domain_name
  cloudfront_zone_id  = module.cloudfront.hosted_zone_id
}

module "roles" {
  source           = "./modules/identity/roles"
  lambda_arn       = module.lambda.lambda_arn
  ses_identity_arn = module.ses.ses_identity_arns
  sfn_arn          = module.step_functions.step_functions_arn
}

module "lambda" {
  source          = "./modules/compute/lambda"
  sender_email    = var.sender_email
  lambda_role_arn = module.roles.lambda_execution_role_arn
}

module "cloudfront" {
  source                         = "./modules/network/cloudfront"
  domain_name                    = ["email.${var.domain_name}"]
  s3_bucket_regional_domain_name = module.s3.bucket_regional_domain_name
  acm_certificate_arn            = module.route53.certificate_arn
  s3_bucket                      = module.s3.s3_bucket
}

module "s3" {
  source                      = "./modules/storage/s3"
  s3_bucket_name              = var.s3_bucket_name
  cloudfront_distribution_arn = module.cloudfront.arn
  step_functions_arn          = module.step_functions.step_functions_arn
  domain_name                 = var.domain_name
}

module "step_functions" {
  source                 = "./modules/workflow/step_functions"
  lambda_arn             = module.lambda.lambda_arn
  step_function_role_arn = module.roles.step_functions_role_arn
  log_group_arn          = module.monitor.log_group_arn
}

module "ses" {
  source             = "./modules/integration/ses"
  ses_sender_email   = var.sender_email
  ses_receiver_email = var.receiver_email
}

module "monitor" {
  source = "./modules/monitor/cloudwatch"
}
