# Deploy Azure Monitor Agent for Windows.

For deploying a VM with Azure Monitor Agent preinstalled, go into terraform folder and execute the following:

``` bash
terraform init
terraform plan -out="plan.tfplan"
terraform apply "plan.tfplan"
```

This could take like 10 minutes to appear in Log Analytics the new Agent.
