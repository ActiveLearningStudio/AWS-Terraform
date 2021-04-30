

resource "aws_security_group" "test-sg" {
  name        = "studio_app_sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Http entry"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Http entry"
    from_port   = 443
    to_port     = 443
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
    Name = "studio-app-sg"
  }
}



resource "aws_instance" "web" {
  ami           = var.ami #data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  availability_zone = var.availability_zone

  key_name = var.key_name
#   subnet_id = aws_subnet.subnet-1.id

  network_interface {
    network_interface_id = aws_network_interface.test-interface.id
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
                sudo docker swarm init
                EOF

  tags = {
    Name = "CurrikiApp Instance"
  }
}

resource "null_resource" "web-cluster" {
    depends_on = [ aws_instance.web, aws_instance.db ]
    provisioner "remote-exec" {
        inline = [
           "git clone https://github.com/ActiveLearningStudio/ActiveLearningStudio-docker-containers.git ~/curriki",
           "cp -r ~/curriki/api/storagetoclone/* ~/curriki/api/storage",
           "sudo chmod 777 -R ~/curriki/api/storage",
           "cp ~/curriki/setup.example.sh ~/curriki/setup.sh",
           "sudo chmod +x ~/curriki/setup.sh",
            "sed -i \"s/terraform_site/${var.terraform_site}/g\" ~/curriki/setup.sh",
            "sed -i \"s/terraform_admin_site/${var.terraform_admin_site}/g\" ~/curriki/setup.sh",
            "sed -i \"s/terraform_tsugi_site/${var.terraform_tsugi_site}/g\" ~/curriki/setup.sh",
            "sed -i \"s/terraform_trax_site/${var.terraform_trax_site}/g\" ~/curriki/setup.sh",
            "sed -i \"s/http_scheme/${var.http_scheme}/g\" ~/curriki/setup.sh",
            "sed -i \"s/react_app_pexel_api/${var.react_app_pexel_api}/g\" ~/curriki/setup.sh",
            "sed -i \"s/react_app_google_captcha/${var.react_app_google_captcha}/g\" ~/curriki/setup.sh",
            "sed -i \"s/react_app_gapi_client_id/${var.react_app_gapi_client_id}/g\" ~/curriki/setup.sh",
            "sed -i \"s/react_app_hubpot/${var.react_app_hubpot}/g\" ~/curriki/setup.sh",
            "sed -i \"s/react_app_h5p_key/${var.react_app_h5p_key}/g\" ~/curriki/setup.sh",

            "sed -i \"s/curriki_app_key/${var.curriki_app_key}/g\" ~/curriki/setup.sh",
            "sed -i \"s/curriki_postgres_db_host/${aws_instance.db.public_ip}/g\" ~/curriki/setup.sh",
            "sed -i \"s/curriki_postgres_db_port/${var.postges_exposed_port}/g\" ~/curriki/setup.sh",
            "sed -i \"s/curriki_postgres_db/${var.postgres_db}/g\" ~/curriki/setup.sh",
            "sed -i \"s/curriki_postgres_user/${var.postgres_user}/g\" ~/curriki/setup.sh",
            "sed -i \"s/curriki_postgres_password/${var.postgres_password}/g\" ~/curriki/setup.sh",
            "sed -i \"s/curriki_mail_username/${var.mail_username}/g\" ~/curriki/setup.sh",
            "sed -i \"s/curriki_mail_password/${var.mail_password}/g\" ~/curriki/setup.sh",
            "sed -i \"s/curriki_mail_from_address/${var.mail_from_address}/g\" ~/curriki/setup.sh",
            "sed -i \"s/curriki_gapi_credentials/${var.gapi_credentials}/g\" ~/curriki/setup.sh",
            "sed -i \"s/curriki_elastic_host/${var.elastic_host}/g\" ~/curriki/setup.sh",
            "sed -i \"s/curriki_elastic_user/${var.elastic_username}/g\" ~/curriki/setup.sh",
            "sed -i \"s/curriki_elastic_password/${var.elastic_password}/g\" ~/curriki/setup.sh",
            "sed -i \"s/curriki_lrs_username/${var.lrs_username}/g\" ~/curriki/setup.sh",
            "sed -i \"s/curriki_lrs_password/${var.lrs_password}/g\" ~/curriki/setup.sh",
            "sed -i \"s/curriki_lrs_db_database/${var.postgres_trax_db}/g\" ~/curriki/setup.sh",
            "sed -i \"s/curriki_mysql_db_host/${aws_instance.db.public_ip}/g\" ~/curriki/setup.sh",
            "sed -i \"s/curriki_mysql_db_port/${var.mysql_local_port}/g\" ~/curriki/setup.sh",
            "sed -i \"s/curriki_tsugi_db_dbname/${var.mysql_database}/g\" ~/curriki/setup.sh",
            "sed -i \"s/curriki_mysql_db_user/${var.mysql_user}/g\" ~/curriki/setup.sh",
            "sed -i \"s/curriki_mysql_db_password/${var.mysql_root_password}/g\" ~/curriki/setup.sh",
            "sed -i \"s/curriki_tsugi_admin_password/${var.tsugi_admin_password}/g\" ~/curriki/setup.sh",
            "sudo sh ~/curriki/setup.sh",
            # "sudo docker stack deploy -c ~/curriki/docker-compose.yml currikistack"
        ]
        connection {
            type = "ssh"
            user        = "ubuntu"
            private_key = file(var.private_key_path)
            host = aws_instance.web.public_ip
        } 
    }
}


