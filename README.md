# Flexing with Bicep

## Running this in Azure

To run the GitHub Actions scripts, you must first create a secret and a variable:

1. Create a secret named `AZURE_CREDENTIALS`
   It must follow the format:

   ```json
   {"clientSecret":  "******","subscriptionId":  "******","tenantId":  "******","clientId":"******"}
   ```

2. Create a variable named `AZURE_RESOURCE_GROUP`
3. Try running the `Validate Azure Configuration` workflow to see if it is working correctly.
   - NOTE: if you are using OIDC authentication with GitHub and Azure, then refer to the documentation in [Azure Login Action](https://github.com/marketplace/actions/azure-login) to correctly configure the credentials.
