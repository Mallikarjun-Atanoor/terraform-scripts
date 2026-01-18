resource "aws_iam_group" "temp" {
  name = "temp"
  path = "/group/"
}

resource "aws_iam_group" "Accountant" {
  name = "Accountant"
  path = "/group/"
}

resource "aws_iam_group" "manager" {
  name = "manager"
  path = "/group/"
}

resource "aws_iam_group_membership" "temp_membership" {
  name  = "temp_group_membership"
  group = aws_iam_group.temp.name

  users = [
    for user in aws_iam_user.name :
    user.name
    if contains(keys(user.tags), "job_title")&& can(regex("(?i)temp", user.tags.job_title))
  ]
}

resource "aws_iam_group_membership" "Accountant_membership" {
  name  = "Accountant_group_membership"
  group = aws_iam_group.Accountant.name

  users = [
    for user in aws_iam_user.name :
    user.name
    if contains(keys(user.tags), "job_title")&& can(regex("(?i)accountant", user.tags.job_title))
  ]
}

resource "aws_iam_group_membership" "manager_membership" {
  name  = "manager_group_membership"
  group = aws_iam_group.manager.name

  users = [
    for user in aws_iam_user.name :
    user.name
    if contains(keys(user.tags), "job_title")&& can(regex("(?i)manager", user.tags.job_title))
  ]
}
