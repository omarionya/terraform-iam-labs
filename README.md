# About the Labs
Demonstrate how use Iam users, roles and policies to restrict access to AWS resources.

## Prerequisites
  - AWS Account

  - AWS CLI installed and configured

  - Terraform installed

  - Basic understanding of:

    - S3

    - IAM

    - JSON policies

    - Terraform commands (init, plan, apply, destroy)

    - Access Keys for each IAM user

## 🔹 LAB 1 – Read-Only S3 Bucket
🎯 Goal

User can list and read objects but cannot upload or delete.

👤 User

lab1-user

🔐 Configure CLI
aws configure --profile lab1

Verify login:
```bash
aws sts get-caller-identity --profile lab1
```
Expected:
```json
{
  "Arn": "arn:aws:iam::ACCOUNT_ID:user/lab1-user"
}
```
🪣 Test Bucket Access
```bash
aws s3 ls s3://lab1-read-only-bucket-12345 --profile lab1
```

✅ Should work
```bash
aws s3 cp file.txt s3://lab1-read-only-bucket-12345 --profile lab1
aws s3 rm s3://lab1-read-only-bucket-12345/file.txt --profile lab1
```
❌ Should return AccessDenied

## 🔹 LAB 2 – Write-Only S3 Bucket
🎯 Goal

User can upload objects only.

👤 User

lab2-user
```bash
aws configure --profile lab2
aws sts get-caller-identity --profile lab2
```

Expected ARN:
```json
arn:aws:iam::ACCOUNT_ID:user/lab2-user
```
🪣 Test Access
```bash
aws s3 ls s3://lab2-write-only-bucket-12345 --profile lab2
```

❌ AccessDenied (List blocked)
```bash
aws s3 cp file-name s3://lab2-write-only-bucket-12345 --profile lab2
```

✅ Upload works
```bash
aws s3 rm s3://lab2-write-only-bucket-12345 --recursive --profile lab2
```
❌ Delete blocked

## 🔹 LAB 3 – Upload, List, Get (No Delete)
🎯 Goal

User can:

List

Upload

Download

❌ Cannot delete

👤 User

lab-upload-user
```bash
aws configure --profile lab3
aws sts get-caller-identity --profile lab3
```

Expected:
```json
arn:aws:iam::ACCOUNT_ID:user/lab-upload-user
```
🪣 Test Access
```bash
aws s3 ls s3://lab3-upload-delete-bucket-12345 --profile lab3
```

✅ Works
```bash
aws s3 cp gcp.png s3://lab3-upload-delete-bucket-12345 --profile lab3
```

✅ Works
```bash
aws s3 rm s3://lab3-upload-delete-bucket-12345 --recursive --profile lab3
```

❌ AccessDenied

## 🔹 LAB 4 – IP Restricted Access
🎯 Goal

Allow access only from a specific public IP.

👤 User

lab4-ip-user

Verify login:
```bash
aws sts get-caller-identity --profile lab4
```
🌐 Get Your Public IP
curl https://checkip.amazonaws.com

Add this IP in IAM policy condition:
```json
"Condition": {
  "IpAddress": {
    "aws:SourceIp": "YOUR_IP/32"
  }
}
```
🪣 Test Access
```bash
aws s3 ls s3://lab4-secure-bucket --profile lab4
```

✅ Works from allowed IP

Switch network (WiFi, hotspot, VPN):
```bash
aws s3 ls s3://lab4-secure-bucket --profile lab4
```

❌ AccessDenied (Implicit deny)

## 🔹 LAB 5 – MFA Restricted Access
🎯 Goal

Ensure you username with mfa configured

configure aws cli for the user

```bash
aws configure --profile lab5
```

Allow access only when MFA is present.

Policy condition example:
```json
"Condition": {
  "Bool": {
    "aws:MultiFactorAuthPresent": "true"
  }
}
```
🧪 Test

Without MFA session:
```bash
aws s3 ls --profile lab5
```

❌ AccessDenied

With MFA session:
```bash
aws sts get-session-token \
  --serial-number arn:aws:iam::ACCOUNT_ID:mfa/username \
  --token-code 123456 \
  --profile lab5
```

Export credentials → Retry → ✅ Works

## 🔹 LAB 6 – Cross-Account S3 Access
🎯 Goal

A user in Account B can assume a role in Account A to access one specific S3 bucket.

Steps:

Trusts a specific IAM user from Account B

Allows that user to assume role using sts:AssumeRole

CreatIAM policy in account B for sts:AssumeRole

Create lab6 profile using account B credentials


Assume Role
```bash
aws sts assume-role \
  --role-arn arn:aws:iam::ACCOUNT_A_ID:role/Lab6-CrossAccountRole \
  --role-session-name cross-test \
  --profile lab6
```
Export credentials or create new profile lab6_new using the given credentials


```bash

[profile lab6-new]
role_arn = arn:aws:iam::ACCOUNT_A_ID:role/Lab6-CrossAccountRole
source_profile = lab6
region = REGION #EXAMPLE US-EAST-1 WITHOUT QUOTES
```

Test access from Account B profile

```bash
aws s3 ls s3://lab6-cross-account-bucket-12345 --profile lab6_new
```

## 🔹 LAB 7 – Cross-Account Role Access
🎯 Goal

User assumes role in another account.

Create profile lab7 using account B user credentials

Assume Role
```bash
aws sts assume-role \
  --role-arn arn:aws:iam::ACCOUNT_A_ID:role/Lab7-CrossAccountRole \
  --role-session-name test \
  --profile lab7
```

Export temporary credentials:

export AWS_ACCESS_KEY_ID=...
export AWS_SECRET_ACCESS_KEY=...
export AWS_SESSION_TOKEN=...

or create new profile using the credentials:

```bash

[profile lab7-new]
role_arn = arn:aws:iam::ACCOUNT_A_ID:role/Lab7-CrossAccountRole
source_profile = lab7
region = REGION  #EXAMPLE US-EAST-1 WITHOUT QUOTES
```

Verify:
```bash
aws sts get-caller-identity --profile lab7_new
```

Should show:
```bash
arn:aws:sts::ACCOUNT_A_ID:assumed-role/Lab7-CrossAccountRole
```

Test:
```bash
aws s3 ls s3://lab7-secure-cross-account-bucket-12345 --profile lab7-new
```


## END
