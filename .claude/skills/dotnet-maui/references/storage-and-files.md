# Storage and File System Reference

## SecureStorage

Securely store sensitive key/value pairs using platform-native encryption.

### Basic Usage

```csharp
// Store a value
await SecureStorage.Default.SetAsync("api_key", "secret-value");
await SecureStorage.Default.SetAsync("auth_token", userToken);

// Retrieve a value (returns null if not found)
string apiKey = await SecureStorage.Default.GetAsync("api_key");
if (apiKey == null)
{
    // Key not found - prompt user or handle missing credential
}

// Remove a specific key
bool removed = SecureStorage.Default.Remove("api_key");

// Clear all secure storage
SecureStorage.Default.RemoveAll();
```

### Dependency Injection Pattern

```csharp
// MauiProgram.cs
builder.Services.AddSingleton<ISecureStorage>(SecureStorage.Default);

// Usage in service
public class AuthService
{
    private readonly ISecureStorage _secureStorage;
    
    public AuthService(ISecureStorage secureStorage)
    {
        _secureStorage = secureStorage;
    }
    
    public async Task<string> GetTokenAsync()
    {
        return await _secureStorage.GetAsync("auth_token");
    }
}
```

### Error Handling

```csharp
try
{
    await SecureStorage.Default.SetAsync("key", "value");
}
catch (Exception ex)
{
    // Handle encryption key changes, corruption, or platform issues
    // Best practice: remove and re-add the key
    SecureStorage.Default.Remove("key");
    await SecureStorage.Default.SetAsync("key", "value");
}
```

### Platform Storage Mechanisms

| Platform | Storage | Encryption |
|----------|---------|------------|
| Android | EncryptedSharedPreferences | AES-256 GCM |
| iOS/Mac | Keychain | Hardware-backed |
| Windows | ApplicationDataContainer | DataProtectionProvider |

### iOS/Mac Catalyst Setup

Enable Keychain entitlement for simulator debugging:

1. Create or edit `Entitlements.plist`:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>keychain-access-groups</key>
    <array>
        <string>$(AppIdentifierPrefix)$(CFBundleIdentifier)</string>
    </array>
</dict>
</plist>
```

2. In project properties, set **Custom Entitlements** to `Entitlements.plist` under iOS Bundle Signing.

**Note:** Remove this entitlement for device deployment unless specifically needed.

### Android Auto Backup Configuration

Exclude SecureStorage from Android backup to prevent encryption key issues:

1. Create `Platforms/Android/Resources/xml/auto_backup_rules.xml`:
```xml
<?xml version="1.0" encoding="utf-8"?>
<full-backup-content>
    <include domain="sharedpref" path="."/>
    <exclude domain="sharedpref" path="${applicationId}.microsoft.maui.essentials.preferences.xml"/>
</full-backup-content>
```

2. Reference in `AndroidManifest.xml`:
```xml
<application android:fullBackupContent="@xml/auto_backup_rules" ...>
```

Or disable backup entirely:
```xml
<application android:allowBackup="false" ...>
```

## File System Helpers

### Directory Paths

```csharp
// App data directory - persisted, backed up
string appDataPath = FileSystem.Current.AppDataDirectory;

// Cache directory - may be cleared by OS
string cachePath = FileSystem.Current.CacheDirectory;
```

| Platform | AppDataDirectory | CacheDirectory |
|----------|-----------------|----------------|
| Android | Context.FilesDir | Context.CacheDir |
| iOS/Mac | Library | Library/Caches |
| Windows | LocalFolder | LocalCacheFolder |

### Reading Bundled Files

Files in `Resources/Raw` are bundled as `MauiAsset`:

```csharp
// Read text file
public async Task<string> ReadBundledTextAsync(string filename)
{
    using Stream stream = await FileSystem.Current.OpenAppPackageFileAsync(filename);
    using StreamReader reader = new(stream);
    return await reader.ReadToEndAsync();
}

// Read JSON and deserialize
public async Task<Config> LoadConfigAsync()
{
    using Stream stream = await FileSystem.Current.OpenAppPackageFileAsync("config.json");
    return await JsonSerializer.DeserializeAsync<Config>(stream);
}

// Read binary file
public async Task<byte[]> ReadBundledBytesAsync(string filename)
{
    using Stream stream = await FileSystem.Current.OpenAppPackageFileAsync(filename);
    using MemoryStream ms = new();
    await stream.CopyToAsync(ms);
    return ms.ToArray();
}
```

**Note:** On Android, `OpenAppPackageFileAsync` streams cannot report their length via `Stream.Length`. Read the entire stream to determine size.

### Copying Bundled Files to Writable Location

Bundled files are read-only. Copy to AppDataDirectory for modification:

```csharp
public async Task<string> CopyBundledFileAsync(string filename)
{
    string targetPath = Path.Combine(FileSystem.Current.AppDataDirectory, filename);
    
    // Skip if already copied
    if (File.Exists(targetPath))
        return targetPath;
    
    using Stream input = await FileSystem.Current.OpenAppPackageFileAsync(filename);
    using FileStream output = File.Create(targetPath);
    await input.CopyToAsync(output);
    
    return targetPath;
}
```

### Working with App Data Directory

```csharp
// Write text file
public async Task SaveTextAsync(string filename, string content)
{
    string path = Path.Combine(FileSystem.Current.AppDataDirectory, filename);
    await File.WriteAllTextAsync(path, content);
}

// Read text file
public async Task<string> LoadTextAsync(string filename)
{
    string path = Path.Combine(FileSystem.Current.AppDataDirectory, filename);
    if (!File.Exists(path))
        return null;
    return await File.ReadAllTextAsync(path);
}

// Save JSON object
public async Task SaveJsonAsync<T>(string filename, T data)
{
    string path = Path.Combine(FileSystem.Current.AppDataDirectory, filename);
    string json = JsonSerializer.Serialize(data);
    await File.WriteAllTextAsync(path, json);
}

// Load JSON object
public async Task<T> LoadJsonAsync<T>(string filename)
{
    string path = Path.Combine(FileSystem.Current.AppDataDirectory, filename);
    if (!File.Exists(path))
        return default;
    string json = await File.ReadAllTextAsync(path);
    return JsonSerializer.Deserialize<T>(json);
}
```

### Cache Management

```csharp
// Save to cache
public async Task CacheDataAsync(string key, string data)
{
    string path = Path.Combine(FileSystem.Current.CacheDirectory, $"{key}.cache");
    await File.WriteAllTextAsync(path, data);
}

// Load from cache with expiration
public async Task<string> GetCachedDataAsync(string key, TimeSpan maxAge)
{
    string path = Path.Combine(FileSystem.Current.CacheDirectory, $"{key}.cache");
    
    if (!File.Exists(path))
        return null;
    
    var fileInfo = new FileInfo(path);
    if (DateTime.UtcNow - fileInfo.LastWriteTimeUtc > maxAge)
    {
        File.Delete(path);
        return null;
    }
    
    return await File.ReadAllTextAsync(path);
}

// Clear cache
public void ClearCache()
{
    var cacheDir = new DirectoryInfo(FileSystem.Current.CacheDirectory);
    foreach (var file in cacheDir.GetFiles())
        file.Delete();
    foreach (var dir in cacheDir.GetDirectories())
        dir.Delete(true);
}
```

## Preferences (Non-Sensitive Data)

For non-sensitive app settings:

```csharp
// Set preferences
Preferences.Default.Set("username", "john");
Preferences.Default.Set("theme", "dark");
Preferences.Default.Set("notifications_enabled", true);
Preferences.Default.Set("last_sync", DateTime.UtcNow);

// Get preferences with defaults
string username = Preferences.Default.Get("username", "guest");
bool notificationsEnabled = Preferences.Default.Get("notifications_enabled", true);

// Check if key exists
bool hasUsername = Preferences.Default.ContainsKey("username");

// Remove specific key
Preferences.Default.Remove("username");

// Clear all preferences
Preferences.Default.Clear();
```

### When to Use Each

| Storage Type | Use For |
|--------------|---------|
| SecureStorage | API keys, tokens, passwords, credentials |
| Preferences | User settings, UI state, non-sensitive config |
| AppDataDirectory | User documents, databases, large files |
| CacheDirectory | Temporary data, downloaded images, API responses |
