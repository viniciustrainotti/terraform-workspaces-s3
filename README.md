# terraform-workspaces-s3

To training to workpsaces uses into Terraform, execute the commands below

```sh
$ # download secret.key from Google Drive
$ git-crypt unlock secret.key
$ cd bucket-tfstate
$ terraform init
$ terraform plan -out="plan.tfout"
$ terraform apply "plan.tfout"
$ cd ../bucket-s3
$ terraform init -backend=true -backend-config="backend.hcl"
$ terraform workspace new dev
$ # verify info into variables and backend.hcl file
$ terraform plan -out="plan.tfout"
$ terraform apply "plan.tfout"
$ terraform workspace new uat
$ terraform plan -out="plan.tfout"
$ terraform apply "plan.tfout"
$ terraform workspace new prod
$ terraform plan -out="plan.tfout"
$ terraform apply "plan.tfout"
```

Verify in AWS console the strutuct was create into bucket tfstate, as backend file to configuration from workspace key.