output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "caller_arn" {
  value = data.aws_caller_identity.current.arn
}

output "caller_user" {
  value = data.aws_caller_identity.current.user_id
}

output "user_names" {
  value = [for user in local.users: "${user.first_name}, ${user.last_name}, ${user.department}, ${user.job_title}"]
}

output "user_password" {
    value = {
        for user, profile in aws_iam_user_login_profile.user_profile:
        user => "password created - user must login on first login"
    }
    sensitive = true

    
}