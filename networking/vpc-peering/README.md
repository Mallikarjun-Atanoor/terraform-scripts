🌐 AWS VPC Peering using Terraform

This project provisions two AWS VPCs in different regions, establishes VPC peering between them, and deploys EC2 instances in each VPC to demonstrate private connectivity using Terraform.

📌 Architecture Overview

Primary VPC (Region 1)

Secondary VPC (Region 2)

VPC Peering Connection between both VPCs

Public subnets in each VPC

Internet Gateways and Route Tables

Security Groups for access

SSH access

ICMP (ping) between VPCs

One EC2 instance per VPC

🧱 Resources Created

aws_vpc

aws_subnet

aws_internet_gateway

aws_route_table

aws_route

aws_vpc_peering_connection

aws_vpc_peering_connection_accepter

aws_security_group

aws_instance