output "subnet_id_az_a" {
  value = data.aws_subnet.zone-a.id
}

output "subnet_id_az_b" {
  value = data.aws_subnet.zone-b.id
}
