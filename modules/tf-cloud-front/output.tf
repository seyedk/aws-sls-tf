output "route53_zoneid" {
  value = data.aws_route53_zone.selected.id
}

output "bucket_name" {
  description = "Map of tag keys and values"
  value       = aws_s3_bucket.website.id
}

output "dns_record_FQDN" {
  value = aws_route53_record.primary.fqdn
}

