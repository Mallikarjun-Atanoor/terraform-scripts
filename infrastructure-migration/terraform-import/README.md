# Terraform EC2 Import Project

This project demonstrates how to **import existing AWS EC2 instances** into **Terraform state** and then manage them using Terraform going forward.

It is focused **only on EC2 instances** (no S3, no other resources).

---

## í³Œ What this project does

- Imports **multiple existing EC2 instances**
- Uses `for_each` to manage instances cleanly
- Uses **Terraform import blocks** (Terraform v1.5+)
- Generates Terraform configuration from imported state
- Prepares EC2 instances for future Terraform management
