output "vpc_id" {
  description = "ID of the VPC"
  value = try(aws_vpc.main.id, "")
}

output "public_subnets" {
  description = "List of public subnet IDs"
  value = try(aws_subnet.public[*].id, "")
}

output "private_subnet" {
  description = "Private subnet ID"
  value = try(aws_subnet.private.id, "")
}

output "sg_allow_tls" {
  description = "ID of the TLS Security Group"
  value = try(aws_security_group.allow_tls.id, "")
}

output "sg_allow_http" {
  description = "ID of the HTTP Security Group"
  value = try(aws_security_group.allow_http.id, "")
}

output "sg_allow_ssh" {
  description = "ID of the SSH Security Group"
  value = try(aws_security_group.allow_ssh.id, "")
}

output "sg_allow_rds_mysql" {
  description = "ID of the RDS(mysql) Security Group"
  value = try(aws_security_group.allow_rds_mysql.id, "")
}

# output "" {
#   description = ""
#   value = try(, "")
# }