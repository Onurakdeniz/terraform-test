terraform {
  cloud {
    organization = "your-organization-name"
    workspaces {
      name = "visa-auto-application"
    }
  }
}