# Platform-Specific Code Reference

## Conditional Compilation

### Platform Symbols

```csharp
#if ANDROID
    // Android-specific code
#elif IOS
    // iOS-specific code
#elif MACCATALYST
    // macOS (Mac Catalyst) specific code
#elif WINDOWS
    // Windows-specific code
#endif
```

### Example: Platform-Specific Service

```csharp
public class DeviceService
{
    public string GetDeviceInfo()
    {
#if ANDROID
        return $"Android {Android.OS.Build.VERSION.Release}";
#elif IOS
        return $"iOS {UIKit.UIDevice.CurrentDevice.SystemVersion}";
#elif MACCATALYST
        return $"macOS {Foundation.NSProcessInfo.ProcessInfo.OperatingSystemVersionString}";
#elif WINDOWS
        return $"Windows {Environment.OSVersion.Version}";
#else
        return "Unknown Platform";
#endif
    }
}
```

### Combining Platforms

```csharp
#if IOS || MACCATALYST
    // Shared iOS and Mac Catalyst code (both use Apple frameworks)
#endif

#if ANDROID || IOS
    // Mobile platforms only
#endif

#if WINDOWS || MACCATALYST
    // Desktop platforms only
#endif
```

## Platforms Folder Structure

Code in `Platforms/{Platform}/` is only compiled for that target:

```
Platforms/
├── Android/
│   ├── MainActivity.cs
│   ├── MainApplication.cs
│   ├── AndroidManifest.xml
│   └── Services/
│       └── AndroidDeviceService.cs
├── iOS/
│   ├── AppDelegate.cs
│   ├── Program.cs
│   ├── Info.plist
│   └── Services/
│       └── iOSDeviceService.cs
├── MacCatalyst/
│   ├── AppDelegate.cs
│   ├── Program.cs
│   ├── Info.plist
│   └── Services/
│       └── MacDeviceService.cs
└── Windows/
    ├── App.xaml
    ├── Package.appxmanifest
    └── Services/
        └── WindowsDeviceService.cs
```

## Partial Classes Pattern

Define shared interface, implement per-platform:

### Shared Definition

```csharp
// Services/DeviceService.cs (in project root)
namespace MyApp.Services;

public partial class DeviceService
{
    public partial string GetDeviceId();
    public partial Task<bool> HasBiometricAsync();
}
```

### Platform Implementations

```csharp
// Platforms/Android/Services/DeviceService.cs
namespace MyApp.Services;

public partial class DeviceService
{
    public partial string GetDeviceId()
    {
        return Android.Provider.Settings.Secure.GetString(
            Android.App.Application.Context.ContentResolver,
            Android.Provider.Settings.Secure.AndroidId);
    }

    public partial async Task<bool> HasBiometricAsync()
    {
        var manager = AndroidX.Biometric.BiometricManager.From(Android.App.Application.Context);
        return manager.CanAuthenticate(AndroidX.Biometric.BiometricManager.Authenticators.BiometricStrong) 
            == AndroidX.Biometric.BiometricManager.BiometricSuccess;
    }
}
```

```csharp
// Platforms/iOS/Services/DeviceService.cs
namespace MyApp.Services;

public partial class DeviceService
{
    public partial string GetDeviceId()
    {
        return UIKit.UIDevice.CurrentDevice.IdentifierForVendor?.ToString() ?? "unknown";
    }

    public partial async Task<bool> HasBiometricAsync()
    {
        var context = new LocalAuthentication.LAContext();
        return context.CanEvaluatePolicy(
            LocalAuthentication.LAPolicy.DeviceOwnerAuthenticationWithBiometrics, 
            out _);
    }
}
```

```csharp
// Platforms/Windows/Services/DeviceService.cs
namespace MyApp.Services;

public partial class DeviceService
{
    public partial string GetDeviceId()
    {
        var systemId = Windows.System.Profile.SystemIdentification.GetSystemIdForPublisher();
        return Convert.ToBase64String(systemId.Id.ToArray());
    }

    public partial async Task<bool> HasBiometricAsync()
    {
        var availability = await Windows.Security.Credentials.UI.UserConsentVerifier
            .CheckAvailabilityAsync();
        return availability == Windows.Security.Credentials.UI.UserConsentVerifierAvailability.Available;
    }
}
```

## Dependency Injection with Platform Services

### Interface Definition

```csharp
// Services/IPlatformService.cs
public interface IPlatformService
{
    string GetDeviceId();
    Task<bool> AuthenticateAsync(string reason);
}
```

### Platform Implementations

```csharp
// Platforms/Android/Services/AndroidPlatformService.cs
public class AndroidPlatformService : IPlatformService
{
    public string GetDeviceId() => 
        Android.Provider.Settings.Secure.GetString(
            Android.App.Application.Context.ContentResolver,
            Android.Provider.Settings.Secure.AndroidId);

    public async Task<bool> AuthenticateAsync(string reason)
    {
        // Android biometric implementation
        return true;
    }
}
```

### Conditional Registration

```csharp
// MauiProgram.cs
public static MauiApp CreateMauiApp()
{
    var builder = MauiApp.CreateBuilder();
    builder.UseMauiApp<App>();

#if ANDROID
    builder.Services.AddSingleton<IPlatformService, Platforms.Android.Services.AndroidPlatformService>();
#elif IOS
    builder.Services.AddSingleton<IPlatformService, Platforms.iOS.Services.iOSPlatformService>();
#elif WINDOWS
    builder.Services.AddSingleton<IPlatformService, Platforms.Windows.Services.WindowsPlatformService>();
#endif

    return builder.Build();
}
```

## Platform-Specific Resources

### Conditional Assets in .csproj

```xml
<ItemGroup>
    <!-- Default icon -->
    <MauiIcon Include="Resources\AppIcon\appicon.svg" ForegroundFile="Resources\AppIcon\appiconfg.svg" />
    
    <!-- Windows-specific icon -->
    <MauiIcon Include="Resources\AppIcon\appicon-windows.svg" 
              Condition="$([MSBuild]::GetTargetPlatformIdentifier('$(TargetFramework)')) == 'windows'" />
</ItemGroup>

<ItemGroup Condition="$([MSBuild]::GetTargetPlatformIdentifier('$(TargetFramework)')) == 'android'">
    <AndroidResource Include="Platforms\Android\Resources\**" />
</ItemGroup>
```

### Platform-Specific XAML

```xml
<ContentPage xmlns="http://schemas.microsoft.com/dotnet/2021/maui">
    <VerticalStackLayout>
        <Label Text="Settings">
            <Label.Text>
                <OnPlatform x:TypeArguments="x:String">
                    <On Platform="iOS" Value="iOS Settings"/>
                    <On Platform="Android" Value="Android Settings"/>
                    <On Platform="WinUI" Value="Windows Settings"/>
                    <On Platform="MacCatalyst" Value="Mac Settings"/>
                </OnPlatform>
            </Label.Text>
        </Label>
        
        <Button>
            <Button.Margin>
                <OnPlatform x:TypeArguments="Thickness">
                    <On Platform="iOS" Value="0,20,0,0"/>
                    <On Platform="Android" Value="0,10,0,0"/>
                </OnPlatform>
            </Button.Margin>
        </Button>
    </VerticalStackLayout>
</ContentPage>
```

## Accessing Native APIs

### Android

```csharp
#if ANDROID
using Android.Content;
using Android.Widget;

public void ShowToast(string message)
{
    var context = Android.App.Application.Context;
    Toast.MakeText(context, message, ToastLength.Short)?.Show();
}
#endif
```

### iOS/Mac Catalyst

```csharp
#if IOS || MACCATALYST
using UIKit;
using Foundation;

public void ShowAlert(string title, string message)
{
    var alert = UIAlertController.Create(title, message, UIAlertControllerStyle.Alert);
    alert.AddAction(UIAlertAction.Create("OK", UIAlertActionStyle.Default, null));
    
    var rootController = UIApplication.SharedApplication.KeyWindow?.RootViewController;
    rootController?.PresentViewController(alert, true, null);
}
#endif
```

### Windows

```csharp
#if WINDOWS
using Windows.UI.Notifications;
using Microsoft.Windows.AppNotifications;

public void ShowNotification(string title, string message)
{
    var builder = new AppNotificationBuilder()
        .AddText(title)
        .AddText(message);
    
    AppNotificationManager.Default.Show(builder.BuildNotification());
}
#endif
```

## Multi-Targeting Configuration

### Custom File Naming Convention

Add to `.csproj` to use filename-based multi-targeting:

```xml
<ItemGroup>
    <!-- Include .android.cs files only for Android -->
    <Compile Include="**\*.android.cs" Condition="$([MSBuild]::GetTargetPlatformIdentifier('$(TargetFramework)')) == 'android'" />
    <Compile Remove="**\*.android.cs" Condition="$([MSBuild]::GetTargetPlatformIdentifier('$(TargetFramework)')) != 'android'" />
    
    <!-- Similar for other platforms -->
    <Compile Include="**\*.ios.cs" Condition="$([MSBuild]::GetTargetPlatformIdentifier('$(TargetFramework)')) == 'ios'" />
    <Compile Remove="**\*.ios.cs" Condition="$([MSBuild]::GetTargetPlatformIdentifier('$(TargetFramework)')) != 'ios'" />
</ItemGroup>
```

Then organize files as:
```
Services/
├── DeviceService.cs          # Shared code
├── DeviceService.android.cs  # Android implementation
├── DeviceService.ios.cs      # iOS implementation
└── DeviceService.windows.cs  # Windows implementation
```
