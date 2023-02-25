module "aws-prod" {
    source = "../../infra"
    instance = "t2.micro"
    region = "us-east-1"
    key = "IaC-PROD"
    tag = "PROD-SRV"
    security_group = "mrf_sec_prod"
    min = 1
    max = 10
    elastic_group_name = "PROD-GRP-SRV" 
    prod = true 
}
