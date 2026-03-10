data "terraform_remote_state" "vpc" {
  backend = "local"

  config = {
    # Path to where your network/terraform.tfstate sits
    path = "../network/terraform.tfstate"
  }
}
