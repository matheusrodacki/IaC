module "aws-dev" {
    source = "../../infra"
    instance = "t2.micro"
    region = "us-east-1"
    key = "IaC-DEV"
    tag = "DEV-SRV"  
}

output "public_ip_dev" {
  value = module.aws-dev.public_ip 
}