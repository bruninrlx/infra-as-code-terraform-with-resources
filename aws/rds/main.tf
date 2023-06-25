resource "aws_db_instance" "default" {
  db_name           = "ecommerce"
  identifier        = "mydb"
  allocated_storage = 20 // quantidade máxima de armazenamento gratuita
  engine            = "postgres"
  engine_version    = "13" // substitua pela versão desejada
  instance_class    = "db.t2.micro" // uma instância de banco de dados gratuita elegível
  username          = "bubu"
  password          = "company"
  parameter_group_name = "default.postgres13"
  skip_final_snapshot = true // evita a criação de um snapshot final ao excluir a instância
}
