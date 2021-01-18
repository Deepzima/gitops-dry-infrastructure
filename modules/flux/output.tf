output "public_key_openssh" {
  value = tls_private_key.flux.public_key_openssh
}

output "private_key_pem" {
  # sensitive = true
  value     = tls_private_key.flux.private_key_pem
}

output "google_access_token" {
  value = data.google_client_config.default.access_token
}

output "flux_namespace" {
  value = var.flux_namespace
}