locals {
  now = formatdate("YYYYMMDDhhmmss", timestamp())
}

data "archive_file" "dist" {
  source_dir  = "${path.module}/../"
  output_file_mode = "0666"
  output_path = "${path.module}/../../zips/lambda-${local.now}.zip"
  type        = "zip"
  excludes = [ "*.tf", "*.tfvars", "*.zip", "*.tfstate", "*.tfstate.backup", "terraform", "terraform.d", "terraform.lock.hcl", "terraform.tfstate", "terraform.tfstate.backup", "zips" ]

  depends_on = [ null_resource.build ]
}

resource "null_resource" "build" {
  triggers = {
    update_at = timestamp()
  }

  provisioner "local-exec" {
    command =<<EOF
    find . -name "*.zip" -type f -delete
    yarn 
    yarn build 
    rm -rf node_modules
    yarn install --production
    EOF
  
    working_dir = "${path.module}/.."
  }
}