// -----------------VPCccccccccccccccccccc------------------------

resource "aws_vpc" "sameep_terraform_vpc" {
  cidr_block = "10.0.0.0/16"
  tags= {
  Name = "sameep_terraform_vpc"
    silo = "intern2"
    owner = "sameep.sigdel"
    terraform = "true"
    environment = "dev"
  }
}

// ----------------Security Groupssssssssssssssss-------------

resource "aws_security_group" "sameep_sg" {
  name        = "sameep_sg_vpc_1_terraform"
  description = "sameep aws securitygroup built using terraform"
  vpc_id      = aws_vpc.sameep_terraform_vpc.id

  ingress{
    description = "sameep security group from terraform ssh"
    cidr_blocks   = ["0.0.0.0/0"]
    from_port   = 22
    protocol = "tcp"
    to_port     = 22
  }

  ingress{
    description = "sameep security group from terraform http"
    cidr_blocks   = ["0.0.0.0/0"]
    from_port   = 80
    protocol = "tcp"
    to_port     = 80
  }

  ingress{
    description = "sameep security group from terraform tcp 3000"
    cidr_blocks   = ["0.0.0.0/0"]
    from_port   = 3000
    protocol = "tcp"
    to_port     = 3000
  }

  ingress{
    description = "sameep security group from terraform tcp 5174"
    cidr_blocks   = ["0.0.0.0/0"]
    from_port   = 5173
    protocol = "tcp"
    to_port     = 5173
  }

  egress{
    description = "egress for all traffic"
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sameep-aws-sg-terraform"
    terraform = "true"
    silo = "intern2"
    owner = "sameep.sigdel"
    environment = "dev"
  }
}

//-------------Subnetsssssssssssssssssss-----------

resource "aws_subnet" "sameep_terraform_subnet_1" {
  vpc_id     = aws_vpc.sameep_terraform_vpc.id
  cidr_block = "10.0.1.0/24"
  # availability_zone = "us-east-1a"

  tags = {
    Name = "sameep_terraform_subnet_1"
    silo = "intern2"
    owner = "sameep.sigdel"
    terraform = "true"
    environment = "dev"
  }
}

# //----------------------Internet Gatewayyyyyyyyyyyyy------------------------------
resource "aws_internet_gateway" "sameep_internet_gateway_1" {
  vpc_id = aws_vpc.sameep_terraform_vpc.id

  tags = {
    Name = "sameep_internet_gateway_1_terraform"
    silo = "intern2"
    owner = "sameep.sigdel"
    terraform = "true"
    environment = "dev"
  }
}

//----------------------Route Tableeeeeeeeeeeeeeeeeeee-----------------------------
resource "aws_route_table" "sameep_route_table_public_1" {
  vpc_id = aws_vpc.sameep_terraform_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.sameep_internet_gateway_1.id
  }
}

//----------------Route Table Associationnnnnnnnnnnn-----------------
resource "aws_route_table_association" "sameep_association_route_table_public_1" {
  subnet_id      = aws_subnet.sameep_terraform_subnet_1.id
  route_table_id = aws_route_table.sameep_route_table_public_1.id
}

// -------------------------IAMMMMMMMMMMMMMMMMMMMMM--------------------------
resource "aws_iam_role" "sameep_ssm_iam_role" {
  name = "sameep_ssm_iam_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

data "aws_iam_policy" "aws_managed_policy" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
}

resource "aws_iam_role_policy_attachment" "role_policy_attachment_SSM" {
  role       = aws_iam_role.sameep_ssm_iam_role.name
  policy_arn = data.aws_iam_policy.aws_managed_policy.arn
}

resource "aws_iam_instance_profile" "sameep_ssm_iam_role_instance_profile" {
  name = "sameep_iam_instance_profile"
  role = aws_iam_role.sameep_ssm_iam_role.name
}