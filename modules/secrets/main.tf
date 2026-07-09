resource "aws_secretsmanager_secret" "db" {
  name = "${var.project_name}/${var.environment}/database"
}

resource "aws_secretsmanager_secret_version" "db" {
  secret_id = aws_secretsmanager_secret.db.id

  secret_string = jsonencode({
    username = var.db_username
    password = var.db_password
    endpoint = var.db_endpoint
    dbname   = var.db_name
  })
}
