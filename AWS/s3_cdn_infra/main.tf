module "s3" {
  source                      = "./modules/storage/s3"
  s3_bucket_name              = var.s3_bucket_name
  cloudfront_distribution_arn = module.cloudfront_distribution.arn
}

module "cloudfront_distribution" {
  source                         = "./modules/network/cloudfront"
  domain_names                   = var.domain_names
  s3_bucket_regional_domain_name = module.s3.bucket_regional_domain_name
  s3_bucket                      = module.s3.s3_bucket
  acm_certificate                = module.route53.acm_certificate
}

module "route53" {
  source                                 = "./modules/network/route53"
  domain_names                           = var.domain_names
  cloudfront_distribution_domain_name    = module.cloudfront_distribution.domain_name
  cloudfront_distribution_hosted_zone_id = module.cloudfront_distribution.hosted_zone_id
  cf_records_map                         = var.cf_records_map
  dns_zone_id                            = module.route53.dns_zone_id
}

module "codebuild" {
  source          = "./modules/deployment/codebuild"
  repository_link = var.repository_link
  s3_bucket_id    = module.s3.s3_bucket_id
  iam_role_arn    = module.iam_roles.codebuild_role_arn
}

module "iam_roles" {
  source = "./modules/identity/roles"
}

module "iam_policies" {
  source                 = "./modules/identity/policies"
  codebuild_role_id      = module.iam_roles.codebuild_role_id
  codebuild_project_name = module.codebuild.project_name
  s3_bucket_arn          = module.s3.s3_bucket_arn
}