---
name: dotnet-maui
description: Specialized knowledge for building cross-platform desktop and mobile apps with .NET MAUI. Use when creating MAUI projects, working with XAML or Blazor Hybrid UI, implementing platform-specific code for Windows/macOS, configuring dependency injection in MauiProgram.cs, implementing Shell navigation, storing API keys with SecureStorage, accessing file system directories, or debugging with XAML Hot Reload.
---

# .NET MAUI Development

## Project Structure

```
MyApp/
├── App.xaml(.cs)           # App-wide resources, Shell initialization
├── AppShell.xaml(.cs)      # Navigation structure and routes
├── MauiProgram.cs          # Bootstrapping, DI configuration
├── MainPage.xaml(.cs)      # Default startup page
├── Platforms/              # Platform-specific code (Android/iOS/Mac/Windows)
├── Resources/Raw/          # Bundled assets (MauiAsset)
└── wwwroot/                # Blazor Hybrid static files (if using)
```

## MauiProgram.cs Essentials

```csharp
public static class MauiProgram
{
    public static MauiApp CreateMauiApp()
    {
        var builder = MauiApp.CreateBuilder();
        builder
            .UseMauiApp<App>()
            .ConfigureFonts(fonts =>
            {
                fonts.AddFont("OpenSans-Regular.ttf", "OpenSansRegular");
            });

        // Register services and pages
        builder.Services.AddSingleton<IMyService, MyService>();
        builder.Services.AddTransient<MainPage>();
        builder.Services.AddTransient<MainViewModel>();

        return builder.Build();
    }
}
```

**Service lifetimes:** `AddSingleton` (one instance), `AddTransient` (new each time), `AddScoped` (per scope).

## UI Pattern Selection

| Choose | When |
|--------|------|
| **XAML** | Native look-and-feel, platform-specific UX, performance-critical UI |
| **Blazor Hybrid** | Sharing code with web apps, existing Razor/Blazor expertise |

For detailed UI implementation patterns, see [references/ui-patterns.md](references/ui-patterns.md).

## Shell Navigation Quick Reference

```csharp
// Absolute (resets stack)
await Shell.Current.GoToAsync("//home");

// Relative (pushes to stack)
await Shell.Current.GoToAsync("details");

// With parameters
await Shell.Current.GoToAsync($"details?id={itemId}");

// Back
await Shell.Current.GoToAsync("..");
```

Register detail pages in AppShell.xaml.cs:
```csharp
Routing.RegisterRoute("details", typeof(DetailsPage));
```

For parameter passing and advanced navigation, see [references/navigation.md](references/navigation.md).

## Platform-Specific Code Quick Reference

```csharp
#if ANDROID
    // Android-only code
#elif IOS
    // iOS-only code
#elif MACCATALYST
    // macOS-only code
#elif WINDOWS
    // Windows-only code
#endif
```

For partial classes and Platforms folder patterns, see [references/platform-specific.md](references/platform-specific.md).

## Storage Quick Reference

```csharp
// Secure storage (API keys, tokens)
await SecureStorage.Default.SetAsync("api_key", "secret");
string key = await SecureStorage.Default.GetAsync("api_key");

// File system paths
string appData = FileSystem.Current.AppDataDirectory;  // Persisted, backed up
string cache = FileSystem.Current.CacheDirectory;       // May be cleared
```

For full storage APIs and platform setup, see [references/storage-and-files.md](references/storage-and-files.md).

## XAML Hot Reload

Enabled by default in Visual Studio with Debug configuration. View XAML changes live without rebuilding.

**Requirements:** Debug config named "Debug", debugger attached, iOS linker set to "Don't Link".

**Limitations:** Doesn't reload C# code. New `x:Name` requires rebuild.

**Troubleshoot:** Check **Debug > Options > XAML Hot Reload**. View output in **View > Output > Hot Reload**.

## Reference Files

| File | Use When |
|------|----------|
| [references/ui-patterns.md](references/ui-patterns.md) | Implementing XAML data binding, Blazor Hybrid setup, MVVM patterns |
| [references/navigation.md](references/navigation.md) | Complex navigation, parameter passing, navigation services |
| [references/platform-specific.md](references/platform-specific.md) | Writing platform-specific code, partial classes, native API access |
| [references/storage-and-files.md](references/storage-and-files.md) | SecureStorage setup, file system access, Android backup config |
