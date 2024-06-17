terraform{
    backend "s3" {
        bucket = "8586-terraform-state"
        key    = "sameep/tfBasicInfra.tfstate"
        region = "us-east-1"      
    }
}