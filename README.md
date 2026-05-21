# static_web_host
Hosting a Static Website in AWS S3 and Cloud-front using Terraform.
User
│
▼
CloudFront
│
▼
S3 Bucket


# File Structure
.
├── backend.tf
├── main.tf
├── output.tf
├── provider.tf
├── variable.tf
└── www/
    ├── index.html
    ├── script.js
    └── style.css


# steps to deploy
terraform init
terraform validate
terraform plan
terraform apply
terraform destroy
