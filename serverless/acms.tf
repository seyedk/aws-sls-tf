module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 3.0"

  domain_name  = "my-domain.com"
  zone_id      = "Z2ES7B9AZ6SHAE"

  subject_alternative_names = [
    "*.my-domain.com",
    "app.sub.my-domain.com",
  ]

  wait_for_validation = true

  tags = {
    Name = "my-domain.com"
  }
}