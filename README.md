# Flexing with Bicep

## Running this in Azure

First gather up the important details:

```shell
az account show
```

This will give you the Subscription ID (which is just called `id`) and the Tenant ID (`tenantId`).

To run the GitHub Actions scripts, you must first create a secret and a variable:

1. Create a secret named `AZURE_CREDENTIALS`
   It must follow the format:

   ```json
   {"clientSecret":  "******","subscriptionId":  "******","tenantId":  "******","clientId":"******"}
   ```

   Where you replace the `******` with the appropriate values.

1. Create a secret named `AZURE_SUBSCRIPTION_ID` with your subscription ID. This is required when using the `Azure/bicep-deploy` action.
1. Create a variable named `AZURE_RESOURCE_GROUP` with your resource group name.
1. Create a variable named `AZURE_LOCATION` with your location (region) name.
1. Try running the `Validate Azure Configuration` workflow to see if it is working correctly.
   - NOTE: if you are using OIDC authentication with GitHub and Azure, then refer to the documentation in [Azure Login Action](https://github.com/marketplace/actions/azure-login) to correctly configure the credentials.
