terraform {
  backend "http" {
    address     = "https://gitlab.mindworking.local/api/v4/projects/165/terraform/state/tes-swarm-cluster"
    lock_address = "https://gitlab.mindworking.local/api/v4/projects/165/terraform/state/tes-swarm-cluster/lock"
    unlock_address = "https://gitlab.mindworking.local/api/v4/projects/165/terraform/state/tes-swarm-cluster/lock"
    username = "test"
    password = "glpat-1Yx-2oDFuJgM6wPaUjFa"
    skip_cert_verification = true
    lock_method = "POST"
    unlock_method= "DELETE"
    retry_wait_min= 5 
  }
}

#terraform init -reconfigure -backend-config=address="http://gitlab.mindworking.local/api/v4/projects/165/terraform/state/dev-swarm-cluster" -backend-config=lock_address="http://gitlab.mindworking.local/api/v4/projects/165/terraform/state/dev-swarm-cluster/lock" -backend-config=unlock_address="http://gitlab.mindworking.local/api/v4/projects/165/terraform/state/dev-swarm-cluster/lock" -backend-config=username="octopus-terraform" -backend-config=password="glpat-4khdqKj-TEBKGKpUcAyf" -backend-config=lock_method=POST -backend-config=unlock_method=DELETE -backend-config=retry_wait_min=5