---
name: electron
description: Build cross-platform desktop applications with Electron. Use when creating new Electron apps, packaging for distribution, configuring auto-updates, implementing native OS integrations (menus, tray, notifications), handling IPC between main/renderer processes, code signing, or troubleshooting Electron security and performance issues.
---

# Electron Desktop Application Development

Build secure, performant cross-platform desktop apps with Electron 27+.

## Quick Start

Initialize new app with Vite template:
```bash
npm create electron-vite@latest my-app -- --template vanilla-ts
cd my-app && npm install && npm run dev
```

Or use Electron Forge:
```bash
npx create-electron-app@latest my-app --template=vite-typescript
cd my-app && npm start
```

## Project Structure

```
my-app/
├── src/
│   ├── main/           # Main process (Node.js)
│   │   └── index.ts
│   ├── preload/        # Preload scripts (bridge)
│   │   └── index.ts
│   └── renderer/       # Renderer process (Chromium)
│       └── index.html
├── electron.vite.config.ts
└── package.json
```

## Security Essentials

Always configure `BrowserWindow` with these security settings:

```typescript
const win = new BrowserWindow({
  webPreferences: {
    contextIsolation: true,      // Required: isolate preload from renderer
    nodeIntegration: false,      // Required: no Node.js in renderer
    sandbox: true,               // Recommended: OS-level sandboxing
    preload: path.join(__dirname, 'preload.js')
  }
});
```

### Secure IPC Pattern

Preload script (exposes safe API):
```typescript
import { contextBridge, ipcRenderer } from 'electron';

contextBridge.exposeInMainWorld('electronAPI', {
  saveFile: (content: string) => ipcRenderer.invoke('save-file', content),
  onUpdateAvailable: (callback: () => void) => 
    ipcRenderer.on('update-available', callback)
});
```

Main process (handles IPC):
```typescript
ipcMain.handle('save-file', async (event, content) => {
  // Validate input before processing
  if (typeof content !== 'string') throw new Error('Invalid content');
  return await fs.writeFile(filePath, content);
});
```

## Packaging & Distribution

### Using Electron Forge

```bash
# Package for current platform
npx electron-forge package

# Create distributable (installer/dmg/deb)
npx electron-forge make

# Publish to configured target
npx electron-forge publish
```

### Using electron-builder

```bash
# Build for current platform
npx electron-builder

# Build for specific platforms
npx electron-builder --mac --win --linux

# Create unpacked directory (for testing)
npx electron-builder --dir
```

Configuration in `package.json`:
```json
{
  "build": {
    "appId": "com.example.myapp",
    "productName": "My App",
    "mac": { "category": "public.app-category.productivity" },
    "win": { "target": ["nsis", "portable"] },
    "linux": { "target": ["AppImage", "deb"] }
  }
}
```

## Code Signing & Notarization

- **macOS signing/notarization**: See [references/macos-signing.md](references/macos-signing.md)
- **Windows signing**: See [references/windows-signing.md](references/windows-signing.md)

## Native OS Integration

### Application Menu
```typescript
import { Menu } from 'electron';

const template = [
  {
    label: 'File',
    submenu: [
      { label: 'New', accelerator: 'CmdOrCtrl+N', click: () => createWindow() },
      { type: 'separator' },
      { role: 'quit' }
    ]
  },
  { role: 'editMenu' },
  { role: 'viewMenu' }
];
Menu.setApplicationMenu(Menu.buildFromTemplate(template));
```

### System Tray
```typescript
import { Tray, Menu } from 'electron';

const tray = new Tray('/path/to/icon.png');
tray.setToolTip('My App');
tray.setContextMenu(Menu.buildFromTemplate([
  { label: 'Show', click: () => win.show() },
  { label: 'Quit', click: () => app.quit() }
]));
```

### Native Notifications
```typescript
import { Notification } from 'electron';

new Notification({
  title: 'Update Available',
  body: 'A new version is ready to install'
}).show();
```

## Auto-Updates

Using electron-updater with electron-builder:

```typescript
import { autoUpdater } from 'electron-updater';

app.whenReady().then(() => {
  autoUpdater.checkForUpdatesAndNotify();
});

autoUpdater.on('update-available', () => {
  // Notify user
});

autoUpdater.on('update-downloaded', () => {
  autoUpdater.quitAndInstall();
});
```

## Performance Guidelines

| Metric | Target |
|--------|--------|
| Cold startup | < 3 seconds |
| Memory (idle) | < 200 MB |
| Installer size | < 100 MB |
| Frame rate | 60 FPS |

Optimization strategies:
- Lazy load renderer modules
- Use `backgroundThrottling: true` for hidden windows
- Defer non-critical initialization with `app.whenReady()`
- Profile with `--inspect` flag and Chrome DevTools

## Native Modules

When using native Node.js modules (C++ addons):

```bash
# Rebuild for Electron's Node version
npx electron-rebuild

# Or with electron-builder
npx electron-builder install-app-deps
```

For persistent native module issues, see [references/native-modules.md](references/native-modules.md).

## Common Issues

| Issue | Solution |
|-------|----------|
| White screen on load | Check `loadFile`/`loadURL` path; enable DevTools |
| IPC not working | Verify `contextIsolation: true` and preload path |
| Native module crash | Run `electron-rebuild` after npm install |
| App rejected by Gatekeeper | Sign and notarize (see references) |
| High memory usage | Check for renderer memory leaks; limit window count |
