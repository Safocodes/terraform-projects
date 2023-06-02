resource "aws_db_subnet_group" "database_subnets_groups" {
  name       = "database subnets"
  subnet_ids = [aws_subnet.private_data_subnet_az1.id, aws_subnet.private_data_subnet_az2.id]

  tags = {
    Name = "db subnet group"
  }
}


resource "aws_db_instance" "db_instance" {
  allocated_storage    = 10
  db_name              = "mydb"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  username             = var.db_username
  password             = var.db_password
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.database_subnets_groups.name
  availability_zone    = "us-east-1b"
  multi_az             = false

}