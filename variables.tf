variable "region" {
  description = "The AWS region to deploy resources in."
  type        = string
  default     = "us-east-1"
}
variable "mfa_user_name" {
  description = "IAM user name for MFA restriction lab."
  type        = string
}
variable "office_ip" {
  description = "The office IP address for IP restriction lab."
  type        = string
}
variable "account_b_id" {
  description = "AWS Account B ID for cross-account access."
  type        = string
}
variable "profile" {
  description = "The AWS profile to use for authentication."
  type        = string
  default     = "aws-lab"
}
variable "user_b_name" {
  description = "IAM user name in Account B for cross-account access."
  type        = string
}
