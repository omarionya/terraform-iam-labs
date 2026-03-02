module "iam_labs" {
  source = "./labs"


  mfa_user_name = var.mfa_user_name
  office_ip     = var.office_ip
  account_b_id  = var.account_b_id
  user_b_name   = var.user_b_name

}