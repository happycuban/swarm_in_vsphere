terraform {
  backend "http" {
    address     = "https://gitlab.mindworking.local/api/v4/projects/165/terraform/state/prod-cluster"
    lock_address = "https://gitlab.mindworking.local/api/v4/projects/165/terraform/state/prod-cluster/lock"
    unlock_address = "https://gitlab.mindworking.local/api/v4/projects/165/terraform/state/prod-cluster/lock"
    username = "mhc@mindworking.dk"
    password        = "glpat-Ud-WxBNyXzfGzniHZY8c"
    skip_cert_verification = true
    lock_method = "POST"
    unlock_method= "DELETE"
    retry_wait_min= 5 
  }
}

#terraform init -migrate-state -backend-config=address="https://gitlab.mindworking.local/api/v4/projects/165/terraform/state/nginx" -backend-config=lock_address="https://gitlab.mindworking.local/api/v4/projects/165/terraform/state/nginx/lock" -backend-config=unlock_address="https://gitlab.mindworking.local/api/v4/projects/165/terraform/state/nginx/lock" -backend-config=username="mhc@mindworking.dk" -backend-config=password="glpat-iQYYsLv3fSPHfcNsKBe6" -backend-config=lock_method=POST -backend-config=unlock_method=DELETE -backend-config=retry_wait_min=5
