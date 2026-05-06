data "aws_caller_identity" "current" {}

resource "aws_iam_user" "name" {
    for_each = { for user in local.users: user.first_name => user}
    name = "${substr(each.value.first_name, 0,1)}${each.value.last_name}"
    path = "/users/"

    tags = {
      "name" = "${each.value.first_name} ${each.value.last_name}"
      "department" = "${each.value.department}"
      "job_title" = "${each.value.job_title}"
    }
} 
  
resource "aws_iam_user_login_profile" "user_profile" {
    for_each = aws_iam_user.name
    user = each.value.name
    password_reset_required = true

    lifecycle {
      ignore_changes = [ password_reset_required, password_length ]

    }


}


