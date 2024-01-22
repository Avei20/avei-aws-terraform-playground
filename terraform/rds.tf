
resource "aws_db_instance" "avei_rds" {
  allocated_storage       = 20
  engine                  = "postgres"
  instance_class          = "db.m5d.large"
  username                = "postgres"
  password                = "postgres"
  multi_az                = false
  vpc_security_group_ids  = [aws_security_group.lambda.id]
  db_subnet_group_name = aws_db_subnet_group.db.name
  db_name                 = "postgres"
  skip_final_snapshot     = true
  apply_immediately       = true
  # final_snapshot_identifier = "avei-rds-final-snapshot"
}

resource "aws_db_subnet_group" "db" {
  name = "avei-rds-subnet-group"
  subnet_ids = [aws_subnet.application_subnet-a.id, aws_subnet.application_subnet-b.id]
}