

# resource "aws_security_group" "db-sg" {
#   name        = "studio_db_sg"
#   description = "Allow TLS inbound traffic"
#   vpc_id      = aws_vpc.main.id

#   ingress {
#     description = "Http entry"
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   ingress {
#     description = "Http entry"
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   ingress {
#     description = "SSH entry"
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "studio-db-sg"
#   }
# }



# resource "aws_instance" "db" {
#   ami           = var.ami #data.aws_ami.ubuntu.id
#   instance_type = var.instance_type
#   availability_zone = var.availability_zone

#   key_name = var.key_name
# #   subnet_id = aws_subnet.subnet-1.id

#   network_interface {
#     network_interface_id = aws_network_interface.test-interface.id
#     device_index         = 0
#   }

#   root_block_device {
#     volume_type = "gp2"
#     volume_size = var.block_volume
#   }
#   user_data = <<-EOF
#                 #!/bin/bash
#                 sudo apt update -y
#                 sudo apt install docker.io -y
#                 sudo curl -L https://github.com/docker/compose/releases/download/1.28.4/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
#                 sudo chmod +x /usr/local/bin/docker-compose
#                 sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
#                 sudo docker swarm init
#                 EOF

#   tags = {
#     Name = "CurrikiDB Instance"
#   }
# }


# # resource "null_resource" "cluster" {
# #     depends_on = [ aws_instance.web ]
# #     provisioner "remote-exec" {
# #         inline = [
# #            "git clone https://github.com/ActiveLearningStudio/ActiveLearningStudio-docker-containers.git studio",
# #            "sudo curl -L https://github.com/docker/compose/releases/download/1.28.4/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose",
# #            "sudo chmod +x /usr/local/bin/docker-compose",
# #            "sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose",
# #            "cd ~/studio",
# #            "git clone --single-branch --branch develop https://github.com/ActiveLearningStudio/ActiveLearningStudio-API.git api",
# #            "git clone --single-branch --branch develop https://github.com/ActiveLearningStudio/ActiveLearningStudio-react-client.git client",
# #            "git clone --single-branch --branch develop https://github.com/ActiveLearningStudio/ActiveLearningStudio-admin-panel.git admin",
# #            "git clone https://github.com/trax-project/trax-lrs.git trax-lrs",
# #            "git clone https://github.com/tsugiproject/tsugi.git tsugi",
# #            "cp Dockerfile.trax trax-lrs/Dockerfile.dev",
# #            "cp Dockerfile.tsugi tsugi/Dockerfile.dev",
# #            "sed -i 's/substitute-terraform-domain.com/${var.terraform_site}/g' init-letsencrypt.sh",
# #            "sed -i 's/substitute-terraform-admin-domain.com/${var.terraform_admin_site}/g' init-letsencrypt.sh",
# #            "sed -i 's/substitute-terraform-tsugi-domain.com/${var.terraform_tsugi_site}/g' init-letsencrypt.sh",
# #            "sed -i 's/substitute-terraform-trax-domain.com/${var.terraform_trax_site}/g' init-letsencrypt.sh",
# #             "sed -i 's/substitute-terraform-domain.com/${var.terraform_site}/g' data/nginx/certbot-conf/app.conf",
# #             "sed -i 's/substitute-terraform-admin-domain.com/${var.terraform_admin_site}/g' data/nginx/certbot-conf/app.conf",
# #             "sed -i 's/substitute-terraform-tsugi-domain.com/${var.terraform_tsugi_site}/g' data/nginx/certbot-conf/app.conf",
# #             "sed -i 's/substitute-terraform-trax-domain.com/${var.terraform_trax_site}/g' data/nginx/certbot-conf/app.conf",
# #             "sed -i 's/substitute-terraform-domain.com/${var.terraform_site}/g' data/nginx/prod-conf/app.conf",
# #             "sed -i 's/substitute-terraform-admin-domain.com/${var.terraform_admin_site}/g' data/nginx/prod-conf/app.conf",
# #             "sed -i 's/substitute-terraform-tsugi-domain.com/${var.terraform_tsugi_site}/g' data/nginx/prod-conf/app.conf",
# #             "sed -i 's/substitute-terraform-trax-domain.com/${var.terraform_trax_site}/g' data/nginx/prod-conf/app.conf",
# #             "cp .env.example .env",
# #             "sleep 120",
# #             "sudo ./init-letsencrypt.sh",
# #             "sudo docker-compose -f docker-compose.yml up -d"
# #         ]
# #         connection {
# #             type = "ssh"
# #             user        = "ubuntu"
# #             private_key = "${file(var.private_key_path)}"
# #             host = "${aws_instance.web.public_ip}"
# #         } 
# #     }
# # }


