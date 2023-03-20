output "address" {
  description = "The DB connection endpoint"
  value = aws_db_instance.example.address
}

output "port" {
  description = "The port the DB is listening to"
  value = aws_db_instance.example.port
}
