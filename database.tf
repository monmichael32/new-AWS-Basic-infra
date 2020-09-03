
resource "aws_security_group" "mongodb" {
  name        = "mongodb"
  description = "Security group for mongodb"
 
  vpc_id=aws_vpc.vpc.id

  tags = {
    Name = "mongodb-prod"
  }
}

resource "aws_security_group_rule" "mongodb_allow_all" {
  type            = "egress"
  from_port       = 0
  to_port         = 0
  protocol        = "-1"
  cidr_blocks     = ["0.0.0.0/0"]

  security_group_id = aws_security_group.mongodb.id
}

resource "aws_security_group_rule" "mongodb_ssh" {
  type            = "ingress"
  from_port       = 22
  to_port         = 22
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]

  security_group_id = aws_security_group.mongodb.id
}

resource "aws_security_group_rule" "mongodb_mongodb" {
  type            = "ingress"
  from_port       = 27017
  to_port         = 27017
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]

  security_group_id = aws_security_group.mongodb.id
}

resource "aws_security_group_rule" "mongodb_mongodb_replication" {
  type            = "ingress"
  from_port       = 27019
  to_port         = 27019
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]

  security_group_id = aws_security_group.mongodb.id
}
resource "aws_s3_bucket" "cts-web-resources" {
    bucket = "cts-web-resources"
    acl    = "public-read"
    #policy = file("policy.json") 
    
    website {
       index_document = "index.html"
       error_document = "error.html"
}
}

