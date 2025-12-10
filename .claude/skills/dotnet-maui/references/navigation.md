# Shell Navigation Reference

## Route Registration

### In AppShell.xaml (Visual Hierarchy)

```xml
<Shell xmlns="http://schemas.microsoft.com/dotnet/2021/maui"
       xmlns:x="http://schemas.microsoft.com/winfx/2009/xaml"
       xmlns:local="clr-namespace:MyApp"
       x:Class="MyApp.AppShell">

    <!-- Tab-based navigation -->
    <TabBar>
        <ShellContent Title="Home" 
                      Route="home" 
                      Icon="home.png"
                      ContentTemplate="{DataTemplate local:HomePage}"/>
        <ShellContent Title="Settings" 
                      Route="settings" 
                      Icon="settings.png"
                      ContentTemplate="{DataTemplate local:SettingsPage}"/>
    </TabBar>

    <!-- Or flyout-based navigation -->
    <FlyoutItem Title="Dashboard" Route="dashboard">
        <ShellContent ContentTemplate="{DataTemplate local:DashboardPage}"/>
    </FlyoutItem>
    <FlyoutItem Title="Profile" Route="profile">
        <ShellContent ContentTemplate="{DataTemplate local:ProfilePage}"/>
    </FlyoutItem>
</Shell>
```

### Programmatic Registration (Detail Pages)

```csharp
// In AppShell.xaml.cs constructor
public AppShell()
{
    InitializeComponent();
    
    // Register pages that will be pushed onto the navigation stack
    Routing.RegisterRoute("details", typeof(DetailsPage));
    Routing.RegisterRoute("edit", typeof(EditPage));
    Routing.RegisterRoute("settings/advanced", typeof(AdvancedSettingsPage));
}
```

## Navigation Methods

### Absolute Routes (Reset Stack)

```csharp
// Navigate to root-level route, clears navigation stack
await Shell.Current.GoToAsync("//home");
await Shell.Current.GoToAsync("//dashboard");
```

### Relative Routes (Push to Stack)

```csharp
// Push onto current navigation stack
await Shell.Current.GoToAsync("details");

// Navigate to nested route
await Shell.Current.GoToAsync("settings/advanced");
```

### Back Navigation

```csharp
// Go back one page
await Shell.Current.GoToAsync("..");

// Go back two pages
await Shell.Current.GoToAsync("../..");

// Go back and navigate to different route
await Shell.Current.GoToAsync("../other");
```

## Parameter Passing

### Query String Parameters

```csharp
// Pass simple parameters
await Shell.Current.GoToAsync($"details?id={itemId}&name={itemName}");

// URL encode if needed
string encodedName = Uri.EscapeDataString(itemName);
await Shell.Current.GoToAsync($"details?name={encodedName}");
```

### Object Parameters

```csharp
// Pass complex objects via dictionary
var parameters = new Dictionary<string, object>
{
    ["item"] = selectedItem,
    ["options"] = new DisplayOptions { ShowDetails = true }
};
await Shell.Current.GoToAsync("details", parameters);
```

### Passing Data Back

```csharp
// Pass data when navigating back
await Shell.Current.GoToAsync($"..?result={selectedValue}");
```

## Receiving Parameters

### QueryProperty Attribute

```csharp
[QueryProperty(nameof(ItemId), "id")]
[QueryProperty(nameof(ItemName), "name")]
public partial class DetailsPage : ContentPage
{
    public string ItemId { get; set; }
    public string ItemName { get; set; }

    protected override void OnNavigatedTo(NavigatedToEventArgs args)
    {
        base.OnNavigatedTo(args);
        // ItemId and ItemName are now set
        LoadItem(ItemId);
    }
}
```

### IQueryAttributable Interface

For complex scenarios or ViewModels:

```csharp
public class DetailsViewModel : ObservableObject, IQueryAttributable
{
    public void ApplyQueryAttributes(IDictionary<string, object> query)
    {
        // String parameters
        if (query.TryGetValue("id", out var id))
            ItemId = id.ToString();

        // Object parameters
        if (query.TryGetValue("item", out var item) && item is MyItem myItem)
            CurrentItem = myItem;

        // Multiple values
        if (query.TryGetValue("tags", out var tags) && tags is string[] tagArray)
            Tags = tagArray.ToList();
    }

    public string ItemId { get; private set; }
    public MyItem CurrentItem { get; private set; }
    public List<string> Tags { get; private set; }
}
```

## Navigation Service Pattern

### Interface

```csharp
public interface INavigationService
{
    Task NavigateToAsync(string route, IDictionary<string, object> parameters = null);
    Task GoBackAsync();
    Task GoToRootAsync();
}
```

### Implementation

```csharp
public class NavigationService : INavigationService
{
    public Task NavigateToAsync(string route, IDictionary<string, object> parameters = null)
    {
        return parameters != null
            ? Shell.Current.GoToAsync(route, parameters)
            : Shell.Current.GoToAsync(route);
    }

    public Task GoBackAsync() => Shell.Current.GoToAsync("..");

    public Task GoToRootAsync() => Shell.Current.GoToAsync("//home");
}
```

### Registration

```csharp
// In MauiProgram.cs
builder.Services.AddSingleton<INavigationService, NavigationService>();
```

### Usage in ViewModel

```csharp
public partial class ListViewModel : ObservableObject
{
    private readonly INavigationService _navigation;

    public ListViewModel(INavigationService navigation)
    {
        _navigation = navigation;
    }

    [RelayCommand]
    private async Task ViewDetailsAsync(Item item)
    {
        var parameters = new Dictionary<string, object> { ["item"] = item };
        await _navigation.NavigateToAsync("details", parameters);
    }
}
```

## Navigation Events

### Intercept Navigation

```csharp
public partial class AppShell : Shell
{
    protected override void OnNavigating(ShellNavigatingEventArgs args)
    {
        base.OnNavigating(args);

        // Cancel back navigation if data unsaved
        if (args.Source == ShellNavigationSource.Pop && HasUnsavedChanges)
        {
            args.Cancel();
        }
    }

    protected override void OnNavigated(ShellNavigatedEventArgs args)
    {
        base.OnNavigated(args);
        // Log navigation, update analytics, etc.
    }
}
```

### Navigation Deferral (Async Confirmation)

```csharp
protected override async void OnNavigating(ShellNavigatingEventArgs args)
{
    base.OnNavigating(args);

    var deferral = args.GetDeferral();

    var result = await DisplayActionSheet("Leave page?", "Cancel", null, "Yes", "No");
    if (result != "Yes")
    {
        args.Cancel();
    }

    deferral.Complete();
}
```

## Back Button Customization

```xml
<ContentPage>
    <Shell.BackButtonBehavior>
        <BackButtonBehavior Command="{Binding BackCommand}"
                            IconOverride="custom_back.png"
                            TextOverride="Cancel"
                            IsVisible="{Binding ShowBackButton}"/>
    </Shell.BackButtonBehavior>
</ContentPage>
```

## Current State and Debugging

```csharp
// Get current navigation state
var currentRoute = Shell.Current.CurrentState.Location.ToString();
var currentPage = Shell.Current.CurrentPage;
var currentItem = Shell.Current.CurrentItem;

// Navigation stack for current tab
var stack = Shell.Current.CurrentItem.CurrentItem.Stack;
```
