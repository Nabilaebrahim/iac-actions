resource "aws_secretsmanager_secret" "cosign_secret" {
  name        = "prod/deployment/cosign"
  description = "Cosign Keys for Image Signing"
}

resource "aws_secretsmanager_secret_version" "cosign_version" {
  secret_id     = aws_secretsmanager_secret.cosign_secret.id
  secret_string = jsonencode({
    COSIGN_PRIVATE_KEY = "placeholder_key"
    COSIGN_PASSWORD    = "placeholder_password"
  })
}