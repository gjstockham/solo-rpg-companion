# macOS Code Signing & Notarization

## Prerequisites

- Apple Developer account ($99/year)
- Xcode Command Line Tools: `xcode-select --install`
- Developer ID certificates (Application + Installer)

## Certificate Setup

1. Open Keychain Access
2. Request certificates from Apple Developer portal:
   - "Developer ID Application" - for signing apps
   - "Developer ID Installer" - for signing PKG installers

Verify installation:
```bash
security find-identity -v -p codesigning
```

## Code Signing

### Manual Signing
```bash
codesign --sign "Developer ID Application: Your Name (TEAM_ID)" \
  --options runtime \
  --entitlements entitlements.plist \
  --deep \
  "My App.app"
```

### With electron-builder

In `package.json` or `electron-builder.yml`:
```yaml
mac:
  hardenedRuntime: true
  gatekeeperAssess: false
  entitlements: build/entitlements.mac.plist
  entitlementsInherit: build/entitlements.mac.plist
```

Required `entitlements.mac.plist`:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>com.apple.security.cs.allow-jit</key>
  <true/>
  <key>com.apple.security.cs.allow-unsigned-executable-memory</key>
  <true/>
  <key>com.apple.security.cs.allow-dyld-environment-variables</key>
  <true/>
</dict>
</plist>
```

### With Electron Forge

In `forge.config.js`:
```javascript
module.exports = {
  packagerConfig: {
    osxSign: {
      identity: 'Developer ID Application: Your Name (TEAM_ID)',
      hardenedRuntime: true,
      entitlements: 'build/entitlements.plist',
      'entitlements-inherit': 'build/entitlements.plist'
    }
  }
};
```

## Notarization

### Using notarytool (Recommended)

Store credentials in Keychain:
```bash
xcrun notarytool store-credentials "AC_PASSWORD" \
  --apple-id "your@email.com" \
  --team-id "TEAM_ID" \
  --password "app-specific-password"
```

Submit for notarization:
```bash
xcrun notarytool submit "My App.dmg" \
  --keychain-profile "AC_PASSWORD" \
  --wait
```

Staple the ticket:
```bash
xcrun stapler staple "My App.dmg"
```

### With electron-builder

Set environment variables:
```bash
export APPLE_ID="your@email.com"
export APPLE_APP_SPECIFIC_PASSWORD="xxxx-xxxx-xxxx-xxxx"
export APPLE_TEAM_ID="TEAM_ID"
```

In configuration:
```yaml
afterSign: scripts/notarize.js
mac:
  notarize: true
```

Or create `scripts/notarize.js`:
```javascript
const { notarize } = require('@electron/notarize');

exports.default = async function notarizing(context) {
  const { electronPlatformName, appOutDir } = context;
  if (electronPlatformName !== 'darwin') return;

  const appName = context.packager.appInfo.productFilename;
  return await notarize({
    appPath: `${appOutDir}/${appName}.app`,
    appleId: process.env.APPLE_ID,
    appleIdPassword: process.env.APPLE_APP_SPECIFIC_PASSWORD,
    teamId: process.env.APPLE_TEAM_ID
  });
};
```

### With Electron Forge

In `forge.config.js`:
```javascript
module.exports = {
  packagerConfig: {
    osxNotarize: {
      appleId: process.env.APPLE_ID,
      appleIdPassword: process.env.APPLE_APP_SPECIFIC_PASSWORD,
      teamId: process.env.APPLE_TEAM_ID
    }
  }
};
```

## Verification

Verify signature:
```bash
codesign --verify --deep --strict --verbose=2 "My App.app"
```

Verify notarization:
```bash
spctl --assess --type execute --verbose "My App.app"
xcrun stapler validate "My App.dmg"
```

## Troubleshooting

| Issue | Solution |
|-------|----------|
| "not signed" error | Check certificate name matches exactly |
| Notarization fails | Check hardened runtime enabled; review log with `xcrun notarytool log <id>` |
| Gatekeeper blocks app | Ensure ticket is stapled to DMG/app |
| "unidentified developer" | Certificate not trusted or missing |

Get notarization log:
```bash
xcrun notarytool log <submission-id> --keychain-profile "AC_PASSWORD"
```
