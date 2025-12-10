# Native Modules in Electron

Native modules (C++ addons) require special handling in Electron because Electron uses a different Node.js version and ABI than system Node.js.

## Rebuilding Native Modules

### Using electron-rebuild (Recommended)
```bash
npx electron-rebuild
```

Options:
```bash
npx electron-rebuild \
  --version 27.0.0 \           # Target Electron version
  --module-dir ./node_modules \ # Module location
  --force                       # Force rebuild all
```

### Using electron-builder
```bash
npx electron-builder install-app-deps
```

Add to `package.json` for automatic rebuilding:
```json
{
  "scripts": {
    "postinstall": "electron-builder install-app-deps"
  }
}
```

### Using node-gyp Directly
```bash
# Set Electron headers
export npm_config_target=27.0.0
export npm_config_arch=x64
export npm_config_disturl=https://electronjs.org/headers
export npm_config_runtime=electron

cd node_modules/your-native-module
node-gyp rebuild
```

## Common Native Modules

| Module | Purpose | Notes |
|--------|---------|-------|
| better-sqlite3 | SQLite database | Needs rebuild |
| sharp | Image processing | Needs rebuild |
| node-pty | Terminal emulation | Needs rebuild |
| keytar | OS keychain access | Needs rebuild |
| serialport | Serial communication | Needs rebuild |
| fsevents | macOS file watching | macOS only |

## Packaging Native Modules

### With electron-builder

Native modules are automatically rebuilt. Configure unpacking if needed:
```yaml
asarUnpack:
  - "node_modules/better-sqlite3/**/*"
  - "**/*.node"
```

### With Electron Forge

```javascript
module.exports = {
  packagerConfig: {
    asar: {
      unpack: '*.node'
    }
  },
  plugins: [
    ['@electron-forge/plugin-auto-unpack-natives']
  ]
};
```

## Platform-Specific Builds

Native modules must be compiled for each target platform. Options:

### 1. Build on Each Platform (CI/CD)
```yaml
# GitHub Actions matrix
strategy:
  matrix:
    os: [ubuntu-latest, windows-latest, macos-latest]
```

### 2. Use Prebuild Binaries

Many modules ship prebuilt binaries via `prebuild` or `prebuildify`:
```bash
# Check for prebuilds
npm install --ignore-scripts
npx prebuild-install
```

### 3. Cross-Compile with Docker

For Linux builds from macOS/Windows:
```bash
docker run --rm -v $(pwd):/app electronuserland/builder \
  /bin/bash -c "cd /app && npm install && npm run build"
```

## node-gyp Prerequisites

### Windows
```powershell
# Install build tools
npm install -g windows-build-tools

# Or install Visual Studio Build Tools manually
# Required: "Desktop development with C++" workload
```

### macOS
```bash
xcode-select --install
```

### Linux
```bash
# Debian/Ubuntu
sudo apt-get install build-essential python3

# Fedora
sudo dnf install gcc-c++ make python3
```

## Troubleshooting

### Module Version Mismatch
```
Error: The module was compiled against a different Node.js version
```

Solution: Rebuild for correct Electron version:
```bash
npx electron-rebuild --version $(npx electron --version | sed 's/v//')
```

### Missing Build Tools (Windows)
```
gyp ERR! find VS
```

Solution:
```powershell
npm config set msvs_version 2022
# Or install: choco install visualstudio2022-workload-vctools
```

### Python Not Found
```
gyp ERR! find Python
```

Solution:
```bash
npm config set python /path/to/python3
# Or: export npm_config_python=/path/to/python3
```

### Architecture Mismatch (Apple Silicon)
```
Error: dlopen: mach-o file, but is an incompatible architecture
```

Solution: Rebuild for correct architecture:
```bash
npm rebuild --arch=arm64
# Or for x64:
npm rebuild --arch=x64
```

### ASAR Extraction Errors
```
Error: ENOENT: cannot find .node file
```

Solution: Unpack native modules from ASAR:
```yaml
# electron-builder.yml
asarUnpack:
  - "**/*.node"
  - "node_modules/better-sqlite3/**/*"
```

## Best Practices

1. **Pin Electron version** - Avoid unexpected ABI changes
2. **Use postinstall script** - Auto-rebuild on npm install
3. **Test on all platforms** - Native modules are platform-specific
4. **Consider alternatives** - Pure JS alternatives avoid native module complexity:
   - `better-sqlite3` → `sql.js` (WASM)
   - `sharp` → `jimp` (pure JS, slower)
   - `bcrypt` → `bcryptjs` (pure JS)
