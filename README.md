# Task 3 – Deploying EC2 Instance with Terraform on AWS

## 🎯 Purpose

The objective of this task was to provision a Virtual Private Cloud (VPC), subnet, Internet Gateway, route table, security group, and an Amazon EC2 instance using Terraform on AWS. This infrastructure setup was performed as part of a hands-on learning activity using the AWS Academy Lab environment to ensure real-world Infrastructure-as-Code (IaC) practices.

---

## 🧱 Architecture Overview

The Terraform configuration includes:
- **VPC**: Custom VPC with CIDR block `10.0.0.0/23`
- **Subnet**: Public subnet `10.0.0.0/24`
- **Internet Gateway**: Attached to the VPC for outbound internet access
- **Route Table**: Configured to route 0.0.0.0/0 via the IGW
- **Security Group**: Allows SSH (port 22) access from anywhere (demo purposes only)
- **EC2 Key Pair**: Created using `tls_private_key` and used to SSH
- **EC2 Instance**: Launched in the public subnet using the specified Ubuntu AMI
- **Outputs**: Public IP, Private IP, and PEM key for SSH

---

## 🛠️ Steps to Run

### ✅ 1. Open the AWS Lab

Login to the AWS Academy lab and open the Cloud9 terminal or shell.

### ✅ 2. Clone or copy the Terraform files
Ensure the following files are present:
- `main.tf`
- `provider.tf`
- `variable.tf`
- `output.tf`
- `vars.tfvars`

### ✅ 3. Initialize Terraform

```bash
terraform init
```

### ✅ 4. Preview the Execution Plan

```bash
terraform plan -var-file="vars.tfvars"
```

### ✅ 5. Apply the Configuration

```bash
terraform apply -var-file="vars.tfvars"
```

You’ll see outputs like:

```
public_ip = "44.220.84.213"
private_ip = "10.0.0.151"
private_key_pem = <sensitive>
```

---

## 🔐 SSH Access to EC2

1. Save the private key:
```bash
terraform output private_key_pem > key.pem
```

2. Fix formatting:
```bash
sed 's/\\n/\n/g' key.pem > fixed_key.pem
chmod 400 fixed_key.pem
```

3. SSH into instance:
```bash
ssh -i fixed_key.pem ec2-user@<public_ip>
```

---

## 🧼 Cleanup

As this was run inside **AWS Academy Lab**, all resources were **automatically destroyed** upon ending the lab session. No manual `terraform destroy` is needed.

---

## ✅ Verification Done

- Logged in via SSH to confirm instance access
- Verified hostname, user, and OS with `whoami`, `hostname`, and `uname -a`

---

## 📌 Notes

- All code used variables and used best practices such as `tls_private_key` for ephemeral key creation
- Region used: `us-east-1`
- AMI used: Ubuntu 24.04 or Amazon Linux 2 (based on availability in lab)