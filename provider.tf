terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.87.0"
    }
  }
}

provider "azurerm" {
  skip_provider_registration = true

  features {}
  
  # client_id       = "916f1688-e642-48b8-b2cf-3186b8adfe81"
  # client_secret   = "NB~8Q~y2XPvPcUa2ckFsVx1yPKuY~OB~IIk5ScwU"
  # tenant_id       = "6e51e1ad-c54b-4b39-b598-0ffe9ae68fef"
  # subscription_id = "00dd52ea-be3f-4deb-aced-2e7091561086"
}