terraform {
  cloud {
    organization = "hashicorp-siddhesh"

    workspaces {
      name = "devops-project"
    }
  }
}