# AWS-Terraform

## Installation

1. Generate / Or use exising AWS key
2. RUN `terraform init`
3. Create terraform.tfvars file with Variables according to variables.tf
4. RUN `terraform apply --auto-approve`

Once it will run, It will generate web server ip in the output. You need to put that ip inside DNS records in order to generate SSL

Once record has been put, login into the web server and run

1. RUN `cd curriki && sudo ./init-letsencrypt.sh`

## TODO

Elastic Search

## Note

Documentaion is still being developed so stay tuned for more
