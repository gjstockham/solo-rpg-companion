---
name: csharp-code-reviewer
description: Automated C# code review for quality, patterns, and best practices. Use when reviewing C# code for: (1) Coding conventions and style, (2) Async/await patterns and potential deadlocks, (3) SOLID principles and testability, (4) Security issues including API key handling and input validation, (5) .NET MAUI-specific gotchas, (6) Performance considerations, (7) Unit testability assessment. Triggers on requests to review C# code, audit .cs files, check for best practices, or analyze code quality.
---

# C# Code Reviewer

Perform systematic code reviews of C# code focusing on quality, patterns, security, and best practices.

## Review Process

1. **Read the code** - Understand structure, purpose, and dependencies
2. **Apply checklist** - Evaluate against each category below
3. **Prioritize findings** - Critical (security/crashes) → Major (bugs/performance) → Minor (style/conventions)
4. **Provide actionable feedback** - Include specific line references and suggested fixes

## Review Categories

### 1. Naming & Conventions

```csharp
// ❌ Bad
public class data_processor { }
private string MyField;
public void process() { }

// ✅ Good
public class DataProcessor { }
private string _myField;
public void Process() { }
```

**Check:**
- PascalCase: types, methods, properties, public members
- camelCase: parameters, local variables
- _camelCase: private fields
- Interfaces prefixed with `I`
- Async methods suffixed with `Async`
- Meaningful names over abbreviations

### 2. Async/Await Patterns

**Critical issues to flag:**

```csharp
// ❌ DEADLOCK RISK - Never do this
var result = GetDataAsync().Result;
var result = GetDataAsync().GetAwaiter().GetResult();
task.Wait();

// ✅ Correct
var result = await GetDataAsync();
```

```csharp
// ❌ async void (except event handlers)
public async void ProcessData() { }

// ✅ async Task
public async Task ProcessDataAsync() { }
```

```csharp
// ❌ Fire-and-forget without handling
_ = ProcessAsync();

// ✅ Proper fire-and-forget
_ = ProcessAsync().ContinueWith(t => 
    Logger.LogError(t.Exception), TaskContinuationOptions.OnlyOnFaulted);
```

**ConfigureAwait guidance:**
- Library code: Use `ConfigureAwait(false)` to avoid capturing context
- UI/MAUI code: Omit `ConfigureAwait` when updating UI after await
- ASP.NET Core: `ConfigureAwait(false)` is optional (no sync context)

### 3. SOLID Principles

**Single Responsibility:**
```csharp
// ❌ Multiple responsibilities
public class UserService {
    public void CreateUser() { }
    public void SendEmail() { }
    public void GeneratePdf() { }
}

// ✅ Single responsibility
public class UserService {
    private readonly IEmailService _email;
    private readonly IPdfService _pdf;
    public void CreateUser() { }
}
```

**Dependency Inversion:**
```csharp
// ❌ Hard-coded dependency - untestable
public class OrderService {
    private readonly SqlDatabase _db = new SqlDatabase();
}

// ✅ Injected dependency - testable
public class OrderService {
    private readonly IDatabase _db;
    public OrderService(IDatabase db) => _db = db;
}
```

**Flag these patterns:**
- Classes with >5 constructor parameters (too many dependencies)
- `new` keyword for services inside classes (use DI instead)
- Static methods accessing external resources
- God classes doing everything

### 4. Security Issues

**API Keys & Secrets:**
```csharp
// ❌ CRITICAL - Hardcoded secrets
private const string ApiKey = "sk-abc123...";
var conn = "Server=prod;Password=secret123";

// ✅ Use configuration/secure storage
var apiKey = Configuration["ApiKey"];
var apiKey = await SecureStorage.GetAsync("api_key");
```

**Input Validation:**
```csharp
// ❌ SQL Injection vulnerable
var sql = $"SELECT * FROM Users WHERE Id = {userId}";

// ✅ Parameterized query
cmd.Parameters.AddWithValue("@Id", userId);
```

```csharp
// ❌ XSS vulnerable in Razor
@Html.Raw(userInput)

// ✅ Auto-encoded
@userInput
```

**Check for:**
- Secrets in source code, config files committed to git
- Raw SQL string concatenation
- Missing input validation on public API endpoints
- `Html.Raw()` with user input
- Missing `[Authorize]` on sensitive endpoints
- Regex without timeout (DoS risk)

### 5. .NET MAUI Gotchas

**Memory leaks from event handlers:**
```csharp
// ❌ Memory leak - event keeps object alive
picker.ValueChanged += OnValueChanged;

// ✅ Unsubscribe or use WeakEventManager
protected override void OnDisappearing() {
    picker.ValueChanged -= OnValueChanged;
}
```

**iOS/Mac Catalyst circular references:**
```csharp
// ❌ Circular reference leak (iOS specific)
class MyView : UIView {
    public MyView() {
        var picker = new UIDatePicker();
        AddSubview(picker);
        picker.ValueChanged += OnValueChanged; // Creates cycle
    }
    void OnValueChanged(object? s, EventArgs e) { }
}

// ✅ Use static handler or proxy
static void OnValueChanged(object? s, EventArgs e) { }
```

**UI thread violations:**
```csharp
// ❌ Updating UI from background thread
await Task.Run(() => {
    label.Text = "Updated"; // May crash
});

// ✅ Marshal to UI thread
await MainThread.InvokeOnMainThreadAsync(() => {
    label.Text = "Updated";
});
```

**Other MAUI issues to flag:**
- Async constructors (use lifecycle events instead)
- Blocking calls in UI code (`Task.Wait()`, `.Result`)
- Missing `ConfigureAwait` in library code
- Unnecessary bindings for static content
- Complex layouts that could be simplified

### 6. Performance

**Collection operations:**
```csharp
// ❌ Multiple enumerations
var count = items.Count();
var first = items.First();

// ✅ Materialize once
var list = items.ToList();
var count = list.Count;
var first = list[0];
```

**String concatenation:**
```csharp
// ❌ In loops
string result = "";
foreach (var s in strings) result += s;

// ✅ StringBuilder for loops
var sb = new StringBuilder();
foreach (var s in strings) sb.Append(s);
```

**Check for:**
- LINQ in tight loops (prefer `for` loops for hot paths)
- Missing `AsNoTracking()` for read-only EF queries
- Large object allocations in frequently called methods
- Boxing of value types
- Excessive exception throwing in normal flow

### 7. Testability Assessment

**Testable code characteristics:**
```csharp
// ✅ Testable
public class OrderProcessor {
    private readonly IOrderRepository _repo;
    private readonly IPaymentGateway _gateway;
    
    public OrderProcessor(IOrderRepository repo, IPaymentGateway gateway) {
        _repo = repo;
        _gateway = gateway;
    }
    
    public async Task<OrderResult> ProcessAsync(Order order) {
        // Logic using injected dependencies
    }
}
```

**Flag untestable patterns:**
- `DateTime.Now`, `Guid.NewGuid()` used directly (inject `ITimeProvider`, `IGuidGenerator`)
- File/network I/O without abstraction
- Static method calls with side effects
- Private methods that need testing (extract to testable class)
- Missing interface for DI registration

## Output Format

Structure review as:

```
## Summary
[1-2 sentence overview of code quality]

## Critical Issues
[Security vulnerabilities, crash risks, deadlock potential]

## Major Issues  
[Bugs, performance problems, SOLID violations]

## Minor Issues
[Style, conventions, suggestions]

## Positive Observations
[Good patterns worth noting]
```

Include line numbers and code snippets for all findings. Provide corrected code examples for critical and major issues.