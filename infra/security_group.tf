resource "aws_security_group" "mrf_sec_group" {
  name = "mrf_sec_group"
  description = "MRF Security Group"
  ingress{
    cidr_blocks = [ "0.0.0.0/0" ]
    ipv6_cidr_blocks = [ "::/0" ]
    from_port = 0
    to_port = 0
    protocol = -1
  }
  egress{
    cidr_blocks = [ "0.0.0.0/0" ]
    ipv6_cidr_blocks = [ "::/0" ]
    from_port = 0
    to_port = 0
    protocol = -1
  }
  tags = {
    Name = "mrf_sec_group"
  }
}