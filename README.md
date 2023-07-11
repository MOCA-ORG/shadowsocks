# Setting up a Shadowsocks server with Terraform

[Qiita](https://qiita.com/haxidoi/items/53c415596236a182428d)

# Deploy
```shell
# copy and modify sample.tfbackend
$ cp sample.tfbackend ./terraform/production.tfbackend

# copy and modify sample.tfvars
$ cp sample.tfvars ./terraform/production.tfvars

# change directory
$ cd ./terraform

# init terraform
$ terraform init -reconfigure -backend-config=production.tfbackend

# apply terraform
$ terraform apply -var-file production.tfvars
```
