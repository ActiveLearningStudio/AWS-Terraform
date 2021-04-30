

resource "aws_security_group" "db-sg" {
  name        = "studio_db_sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Postgres entry"
    from_port   = var.postges_exposed_port
    to_port     = var.postges_exposed_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Pgadmin entry"
    from_port   = var.pgadmin_exposed_port
    to_port     = var.pgadmin_exposed_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "PhpMyAdmin entry"
    from_port   = var.phpmyadmin_exposed_port
    to_port     = var.phpmyadmin_exposed_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "MySQL entry"
    from_port   = var.mysql_local_port
    to_port     = var.mysql_local_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    description = "SSH entry"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "studio-db-sg"
  }
}



resource "aws_instance" "db" {
  ami           = var.ami #data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  availability_zone = var.availability_zone

  key_name = var.key_name
#   subnet_id = aws_subnet.subnet-1.id

  network_interface {
    network_interface_id = aws_network_interface.db-interface.id
    device_index         = 0
  }

  root_block_device {
    volume_type = "gp2"
    volume_size = var.block_volume
  }
  user_data = <<-EOF
                #!/bin/bash
                sudo apt update -y
                sudo apt install docker.io -y
                sudo curl -L https://github.com/docker/compose/releases/download/1.28.4/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
                sudo chmod +x /usr/local/bin/docker-compose
                sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
                EOF

  tags = {
    Name = "CurrikiDB Instance"
  }
}


resource "null_resource" "db-cluster" {
    depends_on = [ aws_instance.db ]
    provisioner "remote-exec" {
        inline = [
           "git clone https://github.com/ActiveLearningStudio/ActiveLearningStudio-docker-db.git curriki-db",
           "sudo mkdir -p /mnt/DBData/currikiprod1-mysqldata",
           "sudo mkdir -p /mnt/DBData/currikiprod1-postgresdata",
           "sudo mkdir -p /mnt/DBData/pgadmin1-data",
           "sed -i 's/substitute-mysql-database/${var.mysql_database}/g' ~/curriki-db/.env.example",
           "sed -i 's/substitute-mysql-user/${var.mysql_user}/g' ~/curriki-db/.env.example",
           "sed -i 's/substitute-mysql-password/${var.mysql_password}/g' ~/curriki-db/.env.example",
           "sed -i 's/substitute-mysql-root-password/${var.mysql_root_password}/g' ~/curriki-db/.env.example",
           "sed -i 's/substitute-mysql-local-port/${var.mysql_local_port}/g' ~/curriki-db/.env.example",
           "sed -i 's/substitute-local-db-ip-address/${aws_instance.db.public_ip}/g' ~/curriki-db/.env.example",
           "sed -i 's/substitute-pgadmin-default-email/${var.pgadmin_default_email}/g' ~/curriki-db/.env.example",
           "sed -i 's/substitute-pgadmin-default-password/${var.pgadmin_default_password}/g' ~/curriki-db/.env.example",
           "sed -i 's/substitute-postgres-user/${var.postgres_user}/g' ~/curriki-db/.env.example",
           "sed -i 's/substitute-postgres-password/${var.postgres_password}/g' ~/curriki-db/.env.example",
           "sed -i 's/substitute-postgres-db/${var.postgres_db}/g' ~/curriki-db/.env.example",
           "sed -i 's/substitute-postgres-exposed-port/${var.postges_exposed_port}/g' ~/curriki-db/.env.example",
           "sed -i 's/substitute-pgadmin-exposed-port/${var.pgadmin_exposed_port}/g' ~/curriki-db/.env.example",
           "sed -i 's/substitute-phpmyadmin-exposed-port/${var.phpmyadmin_exposed_port}/g' ~/curriki-db/.env.example",
           "sed -i 's/substitute-postgres-database/${var.postgres_trax_db}/g' ~/curriki-db/postgresscripts/traxdb.sql",
            "sed -i 's/substitute-postgres-password/${var.postgres_password}/g' ~/curriki-db/postgresscripts/db-update-creds.sql",
           "cp ~/curriki-db/.env.example  ~/curriki-db/.env",
            "cd curriki-db && sudo docker-compose up -d",
            "sudo sh ~/curriki-db/db-update-creds.sh"
        ]
        connection {
            type = "ssh"
            user        = "ubuntu"
            private_key = file(var.private_key_path)
            host = aws_instance.db.public_ip
        } 
    }
}


