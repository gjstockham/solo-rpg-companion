# Microsoft Agent Framework - C# Guide

## Installation

```bash
dotnet add package Azure.AI.OpenAI --prerelease
dotnet add package Azure.Identity
dotnet add package Microsoft.Agents.AI.OpenAI --prerelease
```

## Create an Agent

```csharp
using Azure.AI.OpenAI;
using Azure.Identity;
using Microsoft.Agents.AI;

AIAgent agent = new AzureOpenAIClient(
    new Uri("https://<resource>.openai.azure.com"),
    new AzureCliCredential())
    .GetChatClient("gpt-4o-mini")
    .CreateAIAgent(
        instructions: "You are a helpful assistant.",
        name: "MyAgent");

Console.WriteLine(await agent.RunAsync("Hello!"));
```

## Multi-Turn Conversations

Agents are stateless. Use `AgentThread` for conversation context:

```csharp
AgentThread thread = agent.GetNewThread();
Console.WriteLine(await agent.RunAsync("Tell me a joke.", thread));
Console.WriteLine(await agent.RunAsync("Make it funnier.", thread));
```

## Function Tools

```csharp
using System.ComponentModel;
using Microsoft.Extensions.AI;

[Description("Get weather for a location.")]
static string GetWeather([Description("Location name")] string location)
    => $"Weather in {location}: Sunny, 22°C";

AIAgent agent = chatClient.CreateAIAgent(
    instructions: "You are a helpful assistant",
    tools: [AIFunctionFactory.Create(GetWeather)]);
```

## Agent as Tool

```csharp
AIAgent weatherAgent = chatClient.CreateAIAgent(
    instructions: "You provide weather info.",
    tools: [AIFunctionFactory.Create(GetWeather)]);

AIAgent mainAgent = chatClient.CreateAIAgent(
    instructions: "You respond in French.",
    tools: [weatherAgent.AsAIFunction()]);
```

## Streaming

```csharp
await foreach (var update in agent.RunStreamingAsync("Tell me a story."))
{
    if (update.Contents.FirstOrDefault() is TextContent text)
        Console.Write(text.Text);
}
```

## Structured Output

```csharp
public record WeatherInfo(string Location, double Temperature, string Condition);

var response = await agent.RunAsync<WeatherInfo>("Weather in Seattle?");
Console.WriteLine($"{response.Result.Location}: {response.Result.Temperature}°C");
```

## Human-in-the-Loop Approvals

```csharp
var approvalFunction = AIFunctionFactory.Create(GetWeather, requiresApproval: true);
AIAgent agent = chatClient.CreateAIAgent(
    instructions: "You are helpful", tools: [approvalFunction]);

AgentThread thread = agent.GetNewThread();
var response = await agent.RunAsync("Weather in Paris?", thread);

var approvals = response.Messages
    .SelectMany(m => m.Contents.OfType<FunctionApprovalRequestContent>())
    .ToList();

if (approvals.Any())
{
    var request = approvals.First();
    Console.WriteLine($"Approve '{request.FunctionCall.Name}'? (y/n)");
    bool approved = Console.ReadLine()?.ToLower() == "y";
    
    var msg = new ChatMessage(ChatRole.User, [request.CreateResponse(approved)]);
    Console.WriteLine(await agent.RunAsync(msg, thread));
}
```

## Middleware

```csharp
async IAsyncEnumerable<AgentRunResponseUpdate> LoggingMiddleware(
    AIAgent agent,
    IEnumerable<ChatMessage> messages,
    AgentRunOptions? options,
    Func<IEnumerable<ChatMessage>, AgentRunOptions?, IAsyncEnumerable<AgentRunResponseUpdate>> next,
    CancellationToken ct)
{
    Console.WriteLine($"[{DateTime.Now}] Agent called");
    await foreach (var update in next(messages, options))
        yield return update;
}

var middlewareAgent = agent.AsBuilder().Use(LoggingMiddleware).Build();
```

## Durable Agents (Azure Functions)

```bash
dotnet add package Microsoft.Agents.AI.Hosting.AzureFunctions --prerelease
```

```csharp
using Microsoft.Agents.AI.Hosting.AzureFunctions;

AIAgent agent = new AzureOpenAIClient(new Uri(endpoint), new DefaultAzureCredential())
    .GetChatClient(deploymentName)
    .CreateAIAgent(instructions: "You are helpful.", name: "MyDurableAgent");

using IHost app = FunctionsApplication
    .CreateBuilder(args)
    .ConfigureFunctionsWebApplication()
    .ConfigureDurableAgents(options => options.AddAIAgent(agent))
    .Build();
app.Run();
```

Creates HTTP endpoints automatically for threads, messages, and history.

## Key Packages

| Package | Purpose |
|---------|---------|
| `Microsoft.Agents.AI` | Core framework |
| `Microsoft.Agents.AI.OpenAI` | Azure OpenAI / OpenAI |
| `Microsoft.Agents.Workflows` | Orchestrations |
| `Microsoft.Agents.AI.Hosting.AzureFunctions` | Durable agents |

## Thread Storage by Service

| Service | Storage |
|---------|---------|
| Azure OpenAI ChatCompletion | In-memory (in AgentThread) |
| OpenAI Responses | Service-managed or in-memory |
| Azure AI Foundry Agents | Service-managed |
| OpenAI Assistants | Service-managed |
