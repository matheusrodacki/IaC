module "aws-prod" {
    source = "../../infra"
    instance = "t2.micro"
    region = "us-east-1"
    key = "IaC-PROD"
    tag = "PROD-SRV"  
}