output "web_url" {
    description = "URL"
    value       = "https://${aws_cloudfront_distribution.edge_distro.domain_name}"
}
