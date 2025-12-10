# UI Patterns Reference

## XAML Data Binding

### Basic Page with Bindings

```xml
<ContentPage xmlns="http://schemas.microsoft.com/dotnet/2021/maui"
             xmlns:x="http://schemas.microsoft.com/winfx/2009/xaml"
             x:Class="MyApp.MainPage">
    <VerticalStackLayout Padding="20" Spacing="10">
        <Label Text="{Binding Title}" FontSize="24"/>
        <Entry Text="{Binding SearchText}" Placeholder="Search..."/>
        <Button Text="Submit" Command="{Binding SubmitCommand}"/>
        <CollectionView ItemsSource="{Binding Items}">
            <CollectionView.ItemTemplate>
                <DataTemplate>
                    <Label Text="{Binding Name}"/>
                </DataTemplate>
            </CollectionView.ItemTemplate>
        </CollectionView>
    </VerticalStackLayout>
</ContentPage>
```

### Common Binding Modes

```xml
<!-- Two-way (default for Entry, Editor) -->
<Entry Text="{Binding Name, Mode=TwoWay}"/>

<!-- One-way (default for Label) -->
<Label Text="{Binding Title, Mode=OneWay}"/>

<!-- One-time (set once, no updates) -->
<Label Text="{Binding StaticValue, Mode=OneTime}"/>
```

### Value Converters

```csharp
public class BoolToColorConverter : IValueConverter
{
    public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        => (bool)value ? Colors.Green : Colors.Red;

    public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        => throw new NotImplementedException();
}
```

```xml
<ContentPage.Resources>
    <local:BoolToColorConverter x:Key="BoolToColor"/>
</ContentPage.Resources>

<Label TextColor="{Binding IsActive, Converter={StaticResource BoolToColor}}"/>
```

## Blazor Hybrid Setup

### MauiProgram.cs Configuration

```csharp
public static MauiApp CreateMauiApp()
{
    var builder = MauiApp.CreateBuilder();
    builder
        .UseMauiApp<App>()
        .ConfigureFonts(fonts =>
        {
            fonts.AddFont("OpenSans-Regular.ttf", "OpenSansRegular");
        });

    builder.Services.AddMauiBlazorWebView();
#if DEBUG
    builder.Services.AddBlazorWebViewDeveloperTools();
#endif

    // Register Blazor services
    builder.Services.AddSingleton<WeatherService>();

    return builder.Build();
}
```

### MainPage.xaml with BlazorWebView

```xml
<?xml version="1.0" encoding="utf-8" ?>
<ContentPage xmlns="http://schemas.microsoft.com/dotnet/2021/maui"
             xmlns:x="http://schemas.microsoft.com/winfx/2009/xaml"
             xmlns:b="clr-namespace:Microsoft.AspNetCore.Components.WebView.Maui;assembly=Microsoft.AspNetCore.Components.WebView.Maui"
             xmlns:local="clr-namespace:MyApp"
             x:Class="MyApp.MainPage">
    <b:BlazorWebView HostPage="wwwroot/index.html">
        <b:BlazorWebView.RootComponents>
            <b:RootComponent Selector="#app" ComponentType="{x:Type local:Main}"/>
        </b:BlazorWebView.RootComponents>
    </b:BlazorWebView>
</ContentPage>
```

### wwwroot/index.html

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>My App</title>
    <link href="css/app.css" rel="stylesheet" />
</head>
<body>
    <div id="app">Loading...</div>
    <script src="_framework/blazor.webview.js"></script>
</body>
</html>
```

### Main.razor (Root Component)

```razor
<Router AppAssembly="@typeof(Main).Assembly">
    <Found Context="routeData">
        <RouteView RouteData="@routeData" DefaultLayout="@typeof(MainLayout)" />
    </Found>
    <NotFound>
        <LayoutView Layout="@typeof(MainLayout)">
            <p>Page not found</p>
        </LayoutView>
    </NotFound>
</Router>
```

## MVVM with CommunityToolkit.Mvvm

### ViewModel

```csharp
using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;

public partial class MainViewModel : ObservableObject
{
    private readonly IDataService _dataService;

    public MainViewModel(IDataService dataService)
    {
        _dataService = dataService;
    }

    [ObservableProperty]
    private string title = "Hello";

    [ObservableProperty]
    [NotifyPropertyChangedFor(nameof(FullName))]
    private string firstName = "";

    [ObservableProperty]
    [NotifyPropertyChangedFor(nameof(FullName))]
    private string lastName = "";

    public string FullName => $"{FirstName} {LastName}";

    [ObservableProperty]
    private ObservableCollection<Item> items = new();

    [ObservableProperty]
    [NotifyCanExecuteChangedFor(nameof(SubmitCommand))]
    private bool isValid;

    [RelayCommand]
    private async Task LoadDataAsync()
    {
        var data = await _dataService.GetItemsAsync();
        Items = new ObservableCollection<Item>(data);
    }

    [RelayCommand(CanExecute = nameof(IsValid))]
    private async Task SubmitAsync()
    {
        await _dataService.SaveAsync(Items);
    }
}
```

### Page with Injected ViewModel

```csharp
public partial class MainPage : ContentPage
{
    public MainPage(MainViewModel viewModel)
    {
        InitializeComponent();
        BindingContext = viewModel;
    }
}
```

### XAML Binding

```xml
<ContentPage xmlns="http://schemas.microsoft.com/dotnet/2021/maui"
             xmlns:x="http://schemas.microsoft.com/winfx/2009/xaml"
             xmlns:vm="clr-namespace:MyApp.ViewModels"
             x:Class="MyApp.MainPage"
             x:DataType="vm:MainViewModel">
    <VerticalStackLayout Padding="20">
        <Label Text="{Binding Title}"/>
        <Entry Text="{Binding FirstName}"/>
        <Entry Text="{Binding LastName}"/>
        <Label Text="{Binding FullName}"/>
        <Button Text="Load" Command="{Binding LoadDataCommand}"/>
        <Button Text="Submit" Command="{Binding SubmitCommand}"/>
        <ActivityIndicator IsRunning="{Binding LoadDataCommand.IsRunning}"/>
    </VerticalStackLayout>
</ContentPage>
```

## Explicit DI Container Access

When constructor injection isn't available:

```csharp
public partial class MainPage : ContentPage
{
    public MainPage()
    {
        InitializeComponent();
        HandlerChanged += OnHandlerChanged;
    }

    private void OnHandlerChanged(object sender, EventArgs e)
    {
        if (Handler != null)
        {
            BindingContext = Handler.MauiContext.Services.GetService<MainViewModel>();
        }
    }
}
```

From a ViewModel (not recommended, but possible):

```csharp
var service = Application.Current.Windows[0].Page.Handler.MauiContext.Services.GetService<IMyService>();
```
