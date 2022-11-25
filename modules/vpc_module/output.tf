output "vpc_id" {
value = aws_vpc.create_vpc.id
}

output "subnet_id_out" {
value = aws_subnet.create_pub_sub[1].id
}

output "all_public_subnet" {
value = aws_subnet.create_pub_sub[*].id
}

output "all_private_subnet" {
value = aws_subnet.create_priv_sub[*].id
}