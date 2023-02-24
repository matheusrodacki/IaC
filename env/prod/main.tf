module "aws-prod" {
    source = "../../infra"
    instance = "t2.micro"
    region = "us-east-1"
    key = "IaC-PROD"
    tag = "PROD-SRV"  
}

output "public_ip_prod" {
  value = module.aws-dev.public_ip  
}