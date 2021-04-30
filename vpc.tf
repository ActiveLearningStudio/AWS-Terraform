# Configure the AWS Provider
provider "aws" {
  region = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}


resource "aws_vpc" "main" {
  cidr_block       = var.cidr_block

  tags = {
    Name = "StudioVPC"
  }
}
resource "aws_internet_gateway" "main" {
    vpc_id = aws_vpc.main.id
    tags = {
        Name = "Studio Internet Gateway"
    }
}

resource "aws_route_table" "route-table-1" {
    vpc_id     = aws_vpc.main.id

    tags = {
        Name = "Studio Route Table 1"
    }

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main.id
    }
}



resource "aws_subnet" "subnet-1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet_cidr #"10.0.0.0/24"
  map_public_ip_on_launch = true
  availability_zone = var.availability_zone

  tags = {
    Name = "Studio-subnet 1"
  }
}



resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.route-table-1.id
}


resource "aws_network_interface" "test-interface" {
  subnet_id   = aws_subnet.subnet-1.id
  security_groups = [aws_security_group.test-sg.id]
  private_ips = [var.app_private_ip]

  tags = {
    Name = "studio_network_interface"
  }
}

resource "aws_eip" "one" {
  vpc                       = true
  network_interface         = aws_network_interface.test-interface.id
  associate_with_private_ip = var.app_private_ip
  depends_on = [ aws_internet_gateway.main ]
}

resource "aws_network_interface" "db-interface" {
  subnet_id   = aws_subnet.subnet-1.id
  security_groups = [aws_security_group.test-sg.id]
  private_ips = [var.db_private_ip]

  tags = {
    Name = "db_network_interface"
  }
}

resource "aws_eip" "two" {
  vpc                       = true
  network_interface         = aws_network_interface.db-interface.id
  associate_with_private_ip = var.db_private_ip
  depends_on = [ aws_internet_gateway.main ]
}

resource "aws_eip_association" "eip_assoc1" {
  instance_id   = aws_instance.web.id
  allocation_id = aws_eip.one.id
}
# resource "aws_eip_association" "eip_assoc2" {
#   instance_id   = aws_instance.db.id
#   allocation_id = aws_eip.two.id
# }
# resource "aws_route53_record" "terraform" {
#   zone_id = var.route53_zone
#   name    = var.terraform_site
#   type    = "A"
#   ttl     = "300"
#   records = [aws_instance.web.public_ip]
# }

# resource "aws_route53_record" "terraform-admin" {
#   zone_id = var.route53_zone
#   name    = var.terraform_admin_site
#   type    = "A"
#   ttl     = "300"
#   records = [aws_instance.web.public_ip]
# }


# resource "aws_route53_record" "terraform-tsugi" {
#   zone_id = var.route53_zone
#   name    = var.terraform_tsugi_site
#   type    = "A"
#   ttl     = "300"
#   records = [aws_instance.web.public_ip]
# }


# resource "aws_route53_record" "terraform-trax" {
#   zone_id = var.route53_zone
#   name    = var.terraform_trax_site
#   type    = "A"
#   ttl     = "300"
#   records = [aws_instance.web.public_ip]
# }
