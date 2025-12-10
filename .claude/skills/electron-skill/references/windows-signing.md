# Windows Code Signing

## Certificate Requirements

Since June 2023, Microsoft requires **EV (Extended Validation) code signing certificates** for new publishers to avoid SmartScreen warnings. EV certificates must be stored on hardware security modules (HSM).

### Certificate Options

| Type | SmartScreen Trust | Storage | Use Case |
|------|------------------|---------|----------|
| EV Code Signing | Immediate | HSM/Token | New publishers, enterprises |
| Standard OV | Requires reputation | File (.pfx) | Established publishers only |

### Obtaining Certificates

Trusted providers: DigiCert, Sectigo, GlobalSign, SSL.com

For EV certificates, providers offer:
- Physical USB token
- Cloud HSM signing (recommended for CI/CD)

## Signing with SignTool

### Local Signing (USB Token)
```powershell
signtool sign /tr http://timestamp.digicert.com /td sha256 /fd sha256 /a "MyApp.exe"
```

### Cloud HSM Signing

Most providers offer CLI tools or APIs. Example with Azure SignTool:
```powershell
AzureSignTool sign -kvu "https://myvault.vault.azure.net" \
  -kvi "<client-id>" -kvs "<client-secret>" -kvt "<tenant-id>" \
  -kvc "<cert-name>" -tr http://timestamp.digicert.com -td sha256 \
  "MyApp.exe"
```

## With electron-builder

### Using Local Certificate (.pfx)

Set environment variables:
```powershell
$env:CSC_LINK = "path/to/certificate.pfx"
$env:CSC_KEY_PASSWORD = "certificate-password"
```

Or in `electron-builder.yml`:
```yaml
win:
  certificateFile: path/to/certificate.pfx
  certificatePassword: ${env.WIN_CSC_KEY_PASSWORD}
  signingHashAlgorithms: [sha256]
```

### Using Azure Key Vault (Cloud HSM)

```yaml
win:
  azureSignOptions:
    endpoint: https://myvault.vault.azure.net
    certificateName: my-cert
    clientId: <client-id>
    clientSecret: ${env.AZURE_CLIENT_SECRET}
    tenantId: <tenant-id>
```

### Using Custom Sign Tool

```yaml
win:
  sign: scripts/custom-sign.js
```

`scripts/custom-sign.js`:
```javascript
exports.default = async function(configuration) {
  const { path } = configuration;
  // Call your signing service/tool here
  await execSync(`your-sign-tool sign "${path}"`);
};
```

## With Electron Forge

In `forge.config.js`:
```javascript
module.exports = {
  makers: [
    {
      name: '@electron-forge/maker-squirrel',
      config: {
        certificateFile: process.env.WIN_CERT_PATH,
        certificatePassword: process.env.WIN_CERT_PASSWORD
      }
    }
  ]
};
```

## Timestamping

Always use timestamping to ensure signatures remain valid after certificate expiry:

| Provider | URL |
|----------|-----|
| DigiCert | `http://timestamp.digicert.com` |
| Sectigo | `http://timestamp.sectigo.com` |
| GlobalSign | `http://timestamp.globalsign.com` |

## Verification

```powershell
# Check signature
signtool verify /pa /v "MyApp.exe"

# Check with detailed info
Get-AuthenticodeSignature "MyApp.exe" | Format-List *
```

## CI/CD Integration

### GitHub Actions with Azure Key Vault
```yaml
- name: Sign Windows executable
  uses: azure/login@v1
  with:
    creds: ${{ secrets.AZURE_CREDENTIALS }}
    
- name: Sign with AzureSignTool
  run: |
    dotnet tool install --global AzureSignTool
    AzureSignTool sign -kvu "${{ secrets.AZURE_KEY_VAULT_URL }}" \
      -kvi "${{ secrets.AZURE_CLIENT_ID }}" \
      -kvt "${{ secrets.AZURE_TENANT_ID }}" \
      -kvs "${{ secrets.AZURE_CLIENT_SECRET }}" \
      -kvc "${{ secrets.AZURE_CERT_NAME }}" \
      -tr http://timestamp.digicert.com -td sha256 \
      "dist/*.exe"
```

### Using Cloud Signing Services

Providers like SSL.com and DigiCert offer cloud signing APIs:
```javascript
// Example: SSL.com eSigner
const response = await fetch('https://cs.ssl.com/v1/sign', {
  method: 'POST',
  headers: { 'Authorization': `Bearer ${apiKey}` },
  body: formData
});
```

## Troubleshooting

| Issue | Solution |
|-------|----------|
| SmartScreen warning | Use EV certificate or build reputation over time |
| "Unknown publisher" | Certificate not properly applied; verify with signtool |
| Timestamp failure | Try alternate timestamp server |
| CI signing fails | Check HSM/token connectivity; use cloud HSM for CI |

## SmartScreen Reputation

With standard (non-EV) certificates, reputation builds over time:
- Downloads and installs contribute to reputation
- Consistent publisher identity helps
- EV certificates bypass reputation requirement
