module "aws-dev" {
    source = "../../infra"
    instance = "t2.micro"
    region = "us-east-1"
    key = "IaC-DEV"
    tag = "DEV-SRV"
    security_group = "mrf_sec_dev"
    min = 0
    max = 1
    elastic_group_name = "DEV-GRP-SRV"
    prod = false    
}