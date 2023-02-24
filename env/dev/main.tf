module "aws-dev" {
    source = "../../infra"
    instance = "t2.micro"
    region = "us-east-1"
    key = "IaC-DEV"
    tag = "DEV-SRV"  
}