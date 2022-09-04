# VPC Definition ----------

resource "aws_vpc" "main" {
  cidr_block           = var.cidr
  enable_dns_support   = var.dns_support
  enable_dns_hostnames = var.dns_hostname

  tags = merge(
    { "Name" = var.name },
    var.tags,
    var.vpc_tags,
  )
}

locals {
  vpc_id = aws_vpc.main.id
}

# Internet Gateway Definition ----------
resource "aws_internet_gateway" "main" {
  vpc_id = local.vpc_id

  tags = merge(
    { "Name" = var.name },
    var.tags,
    var.igw_tags,
  )
}

# Subnet Definition ----------

## Public Subnet -----
resource "aws_subnet" "public" {
  vpc_id = local.vpc_id
  # cidr_block        = var.public_subnet
  # availability_zone = var.az

  count             = length(var.public_subnets) > 0 && (length(var.public_subnets) >= length(var.azs)) ? length(var.public_subnets) : 0
  cidr_block        = element(concat(var.public_subnets, [""]), count.index)
  availability_zone = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) > 0 ? element(var.azs, count.index) : null

  # tags = merge(
  #   {
  #     "Name" = format(
  #       "${var.name}-${var.public_subnet_suffix}"
  #     )
  #   },
  #   var.tags,
  #   var.public_subnet_tags,
  # )

  tags = merge(
    {
      "Name" = format(
        "${var.name}-${var.public_subnet_suffix}-%s",
        element(var.azs, count.index),
      )
    },
    var.tags,
    var.public_subnet_tags,
  )
}

## Private Subnet -----
resource "aws_subnet" "private" {
  vpc_id            = local.vpc_id
  cidr_block        = var.private_subnet
  availability_zone = var.azs[0]

  tags = merge(
    {
      "Name" = format(
        "${var.name}-${var.private_subnet_suffix}"
      )
    },
    var.tags,
    var.private_subnet_tags,
  )
}

# Route Table Definition ----------

## Public -----
resource "aws_route_table" "public" {
  vpc_id = local.vpc_id

  tags = merge(
    { "Name" = "${var.name}-${var.public_subnet_suffix}" },
    var.tags,
    var.public_route_table_tags,
  )
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
  depends_on             = [aws_route_table.public]

  timeouts {
    create = "5m"
  }
}

## Private -----
resource "aws_route_table" "private" {
  vpc_id = local.vpc_id

  tags = merge(
    { "Name" = "${var.name}-${var.private_subnet_suffix}" },
    var.tags,
    var.private_route_table_tags,
  )
}

# Route Table Association ----------

## Public -----
resource "aws_route_table_association" "public" {
  route_table_id = aws_route_table.public.id
  # subnet_id = aws_subnet.public.id

  count     = length(var.public_subnets) > 0 ? length(var.public_subnets) : 0
  subnet_id = element(aws_subnet.public[*].id, count.index)
}

## Private -----
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

# Security Groups ----------
resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = local.vpc_id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block, "0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(
    { Name = "allow_tls-${var.name}" },
    var.tags,
  )
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow HTTP inbound traffic"
  vpc_id      = local.vpc_id

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block, "0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(
    { Name = "allow_http-${var.name}" },
    var.tags,
  )
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH traffic"
  vpc_id      = local.vpc_id

  ingress {
    description = "Allow SSH Connection"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block, "0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(
    { Name = "allow_ssh-${var.name}" },
    var.tags,
  )
}