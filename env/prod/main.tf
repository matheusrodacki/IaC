module "aws-prod" {
    source = "../../infra"
    instance = "t2.micro"
    region = "us-east-1"
    key = "IaC-PROD"
    tag = "PROD-SRV"
    security_group = "mrf_sec_prod"  
}

output "public_ip_prod" {
  value = module.aws-prod.public_ip
}