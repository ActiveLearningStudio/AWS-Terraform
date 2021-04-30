variable "subnet_cidr" {
  description = "subnet_cidr"
  type = string
}
variable "db_subnet_cidr" {
  description = "db_subnet_cidr"
  type = string
}

variable "private_key_path" {
  description = "private_key_path"
  type = string
}

variable "route53_zone" {
  description = "route53_zone"
  type = string
}

variable "region" {
  description = "region"
  type = string
}

variable "access_key" {
  description = "access_key"
  type = string
}
variable "secret_key" {
  description = "secret_key"
  type = string
}


variable "cidr_block" {
  description = "cidr_block"
  type = string
}

variable "availability_zone" {
  description = "availability_zone"
  type = string
}

variable "instance_type" {
  description = "instance_type"
  type = string
}

variable "key_name" {
  description = "key_name"
  type = string
}

variable "ami" {
  description = "ami"
  type = string
}

variable "block_volume" {
  description = "block_volume"
  type = string
}

variable "app_private_ip" {
  description = "app_private_ip"
  type = string
}
variable "db_private_ip" {
  description = "db_private_ip"
  type = string
}



variable "terraform_site" {
  description = "terraform_site"
  type = string
}
variable "terraform_admin_site" {
  description = "terraform_admin_site"
  type = string
}
variable "terraform_tsugi_site" {
  description = "terraform_tsugi_site"
  type = string
}
variable "terraform_trax_site" {
  description = "terraform_trax_site"
  type = string
}
variable "http_scheme" {
  description = "http_scheme"
  type = string
}


variable "curriki_app_key" {
  description = "curriki_app_key"
  type = string
}

# variable "mysql_host" {
#   description = "mysql_host"
#   type = string
# }

variable "mysql_database" {
  description = "mysql_database"
  type = string
}
variable "elastic_host" {
  description = "elastic_host"
  type = string
}
variable "elastic_password" {
  description = "elastic_password"
  type = string
}
variable "elastic_username" {
  description = "elastic_username"
  type = string
}
variable "mysql_user" {
  description = "mysql_user"
  type = string
}
variable "mysql_password" {
  description = "mysql_password"
  type = string
}
variable "mysql_root_password" {
  description = "mysql_root_password"
  type = string
}
variable "mysql_local_port" {
  description = "mysql_local_port"
  type = string
}
variable "phpmyadmin_exposed_port" {
  description = "phpmyadmin_exposed_port"
  type = string
}

variable "pgadmin_default_email" {
  description = "pgadmin_default_email"
  type = string
}
variable "pgadmin_default_password" {
  description = "pgadmin_default_password"
  type = string
}

# variable "postgres_host" {
#   description = "postgres_host"
#   type = string
# }
variable "postgres_user" {
  description = "postgres_user"
  type = string
}
variable "postgres_password" {
  description = "postgres_password"
  type = string
}
variable "postgres_db" {
  description = "postgres_db"
  type = string
}
variable "postgres_trax_db" {
  description = "postgres_trax_db"
  type = string
}
variable "postges_exposed_port" {
  description = "postges_exposed_port"
  type = string
}

variable "react_app_pexel_api" {
  description = "react_app_pexel_api"
  type = string
}
variable "react_app_google_captcha" {
  description = "react_app_google_captcha"
  type = string
}
variable "react_app_gapi_client_id" {
  description = "react_app_gapi_client_id"
  type = string
}
variable "react_app_hubpot" {
  description = "react_app_hubpot"
  type = string
}
variable "react_app_h5p_key" {
  description = "react_app_h5p_key"
  type = string
}

variable "tsugi_admin_password" {
  description = "tsugi_admin_password"
  type = string
}

variable "pgadmin_exposed_port" {
  description = "pgadmin_exposed_port"
  type = string
}

variable "mail_username" {
  description = "mail_username"
  type = string
}

variable "mail_password" {
  description = "mail_password"
  type = string
}

variable "mail_from_address" {
  description = "mail_from_address"
  type = string
}


variable "gapi_credentials" {
  description = "gapi_credentials"
  type = string
}

variable "lrs_username" {
  description = "lrs_username"
  type = string
}

variable "lrs_password" {
  description = "lrs_password"
  type = string
}


