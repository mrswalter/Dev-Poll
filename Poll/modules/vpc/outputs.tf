output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnets" {
  value = aws_subnet.public[*].id
}

output "private_subnets_map" {
  value = {
    for i, subnet in aws_subnet.private :
    "subnet_${i}" => subnet.id
  }
}

output "private_subnets" {
  value = aws_subnet.private[*].id
}