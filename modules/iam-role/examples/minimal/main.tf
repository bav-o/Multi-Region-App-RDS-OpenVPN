module "iam_role" {
  source = "../../"

  name = "example-app-role"

  tags = {
    Environment = "dev"
  }
}

output "instance_profile_name" {
  value = module.iam_role.instance_profile_name
}
