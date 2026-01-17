resource "aws_vpc" "vpc-demo-primary" {
  cidr_block         = var.primary_vpc_cidr
  provider           = aws.primary
  enable_dns_hostnames = true
  enable_dns_support = true
  instance_tenancy   = "default"

  tags = {
    name = "vpc-${var.primary_vpc_cidr}"
  }
}

resource "aws_vpc" "vpc-demo-secondary" {
  cidr_block         = var.secondary_vpc_cidr
  provider           = aws.secondary
  enable_dns_hostnames = true
  enable_dns_support = true
  instance_tenancy   = "default"

  tags = {
    name = "vpc-${var.secondary_vpc_cidr}"
  }
}

resource "aws_subnet" "primary_subnet" {
  provider = aws.primary
  vpc_id     = aws_vpc.vpc-demo-primary.id
  cidr_block = var.primary_vpc_cidr
  availability_zone = data.aws_availability_zones.primary.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "primary vpc subnet"
  }
}

resource "aws_subnet" "secondary_subnet" {
  vpc_id     = aws_vpc.vpc-demo-secondary.id
  provider = aws.secondary
  cidr_block = var.secondary_vpc_cidr
  availability_zone = data.aws_availability_zones.secondary.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "secondary vpc subnet"
  }
}

resource "aws_internet_gateway" "primary_internet_gateway" {
    provider = aws.primary
    vpc_id = aws_vpc.vpc-demo-primary.id

    tags = {
      name = "primary internet gateway"
    }
}

resource "aws_internet_gateway" "secondary_internet_gateway" {
    provider = aws.secondary
    vpc_id = aws_vpc.vpc-demo-secondary.id

    tags = {
      name = "secondary internet gateway"
    }
}

resource "aws_route_table" "primary_rt" {
  provider = aws.primary
  vpc_id = aws_vpc.vpc-demo-primary.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.primary_internet_gateway.id
  }
  tags = {
    name = "primary route table"
  }
} 

resource "aws_route_table" "secondary_rt" {
  provider = aws.secondary
  vpc_id = aws_vpc.vpc-demo-secondary.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.secondary_internet_gateway.id
  }
  tags = {
    name = "secondary route table"
  }
} 

resource "aws_route_table_association" "primary-rt-association" {
    provider = aws.primary
    subnet_id = aws_subnet.primary_subnet.id
    route_table_id = aws_route_table.primary_rt.id
}

resource "aws_route_table_association" "secondary-rt-association" {
    provider = aws.secondary
    subnet_id = aws_subnet.secondary_subnet.id
    route_table_id = aws_route_table.secondary_rt.id
}

resource "aws_vpc_peering_connection" "primary_to_secondary_peer" {
  provider = aws.primary
  peer_vpc_id   = aws_vpc.vpc-demo-secondary.id
  peer_region   = var.secondary
  vpc_id        = aws_vpc.vpc-demo-primary.id
  auto_accept   = false

  tags = {
    Name = "primary to secondary peering connection"
    Description = "This is vpc peering connection from primary to secondary"
  }
}

# Add route to Secondary VPC in Primary route table
resource "aws_route" "primary_to_secondary_route" {
  provider                  = aws.primary
  route_table_id            = aws_route_table.primary_rt.id
  destination_cidr_block    = var.secondary_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.primary_to_secondary_peer.id
  depends_on = [aws_vpc_peering_connection_accepter.secondary_accepter]
}

resource "aws_route" "secondary_to_primary_route" {
  provider                  = aws.secondary
  route_table_id            = aws_route_table.secondary_rt.id
  destination_cidr_block    = var.primary_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.primary_to_secondary_peer.id

  depends_on = [aws_vpc_peering_connection_accepter.secondary_accepter]
}


# VPC Peering Connection Accepter (Accepter side - Secondary VPC)
resource "aws_vpc_peering_connection_accepter" "secondary_accepter" {
  provider                  = aws.secondary
  vpc_peering_connection_id = aws_vpc_peering_connection.primary_to_secondary_peer.id
  auto_accept               = true

  tags = {
    Name        = "Secondary-Peering-Accepter"
    Side        = "Accepter"
  }
}

# #VPC connection from secondary to primary
# resource "aws_vpc_peering_connection" "secondary_to_primary_peer" {
#   provider = aws.secondary
#   peer_vpc_id   = aws_vpc.vpc-demo-primary.id
#   peer_region   = var.primary
#   vpc_id        = aws_vpc.vpc-demo-secondary.id
#   auto_accept   = false

#   tags = {
#     Name = "secondary to primary peering connection"
#     Description = "This is vpc peering connection from secondary to primary"
#   }
# }

## Security Group for Primary VPC EC2 instance
resource "aws_security_group" "primary_sg" {
  provider    = aws.primary
  name        = "primary-vpc-sg"
  description = "Security group for Primary VPC instance"
  vpc_id      = aws_vpc.vpc-demo-primary.id

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ICMP from Secondary VPC"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.secondary_vpc_cidr]
  }

  ingress {
    description = "All traffic from Secondary VPC"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [var.secondary_vpc_cidr]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "Primary-VPC-SG"
    Environment = "Demo"
  }
}

# Security Group for Secondary VPC EC2 instance
resource "aws_security_group" "secondary_sg" {
  provider    = aws.secondary
  name        = "secondary-vpc-sg"
  description = "Security group for Secondary VPC instance"
  vpc_id      = aws_vpc.vpc-demo-secondary.id

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ICMP from Primary VPC"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.primary_vpc_cidr]
  }

  ingress {
    description = "All traffic from Primary VPC"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [var.primary_vpc_cidr]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "Secondary-VPC-SG"
    Environment = "Demo"
  }
}

# EC2 Instance in Primary VPC
resource "aws_instance" "primary_instance" {
  provider               = aws.primary
  ami                    = data.aws_ami.primary_ami.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.primary_subnet.id
  vpc_security_group_ids = [aws_security_group.primary_sg.id]
  key_name               = var.primary_key_name

  user_data = local.primary_user_data

  tags = {
    Name        = "Primary-VPC-Instance"
    Environment = "Demo"
    Region      = var.primary
  }

  depends_on = [aws_vpc_peering_connection_accepter.secondary_accepter]
}

# EC2 Instance in Secondary VPC
resource "aws_instance" "secondary_instance" {
  provider               = aws.secondary
  ami                    = data.aws_ami.secondary_ami.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.secondary_subnet.id
  vpc_security_group_ids = [aws_security_group.secondary_sg.id]
  key_name               = var.secondary_key_name

  user_data = local.secondary_user_data

  tags = {
    Name        = "Secondary-VPC-Instance"
    Environment = "Demo"
    Region      = var.secondary
  }

  depends_on = [aws_vpc_peering_connection_accepter.secondary_accepter]
}
