output "vpc_id" {
  value = aws_vpc.project-vpc.id
}

output "pub_subnet_id_1" {
  value = aws_subnet.pub-subnet-1.id
}

output "pub_subnet_id_2" {
  value = aws_subnet.pub-subnet-2.id
}

output "pr_subnet_id_1" {
  value = aws_subnet.pr-subnet-1.id
}

output "pr_subnet_id_2" {
  value = aws_subnet.pr-subnet-2.id
}