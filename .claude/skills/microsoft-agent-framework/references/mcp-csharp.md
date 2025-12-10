# MCP Integration - C#

Model Context Protocol for connecting agents to external tools and data.

## Expose Agent as MCP Tool

```bash
dotnet add package Microsoft.Extensions.Hosting --prerelease
dotnet add package ModelContextProtocol --prerelease
```

```csharp
using Microsoft.Agents.AI;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using ModelContextProtocol.Server;

// Create agent
AIAgent agent = new AzureOpenAIClient(
    new Uri("https://<resource>.openai.azure.com"),
    new AzureCliCredential())
    .GetChatClient("gpt-4o-mini")
    .CreateAIAgent(instructions: "You tell jokes.", name: "Joker");

// Convert to MCP tool
McpServerTool tool = McpServerTool.Create(agent.AsAIFunction());

// Host MCP server
HostApplicationBuilder builder = Host.CreateEmptyApplicationBuilder(settings: null);
builder.Services
    .AddMcpServer()
    .WithStdioServerTransport()
    .WithTools([tool]);

await builder.Build().RunAsync();
```

## Use MCP Tools in Agent

```csharp
using Microsoft.Extensions.AI;
using ModelContextProtocol.Client;

// Create chat client with function invocation
IChatClient client = new ChatClientBuilder(
    new AzureOpenAIClient(new Uri("<endpoint>"), new DefaultAzureCredential())
        .GetChatClient("gpt-4o").AsIChatClient())
    .UseFunctionInvocation()
    .Build();

// Connect to MCP server
IMcpClient mcpClient = await McpClientFactory.CreateAsync(
    new StdioClientTransport(new()
    {
        Command = "dotnet",
        Arguments = ["run", "--project", "<mcp-server-path>"],
        Name = "My MCP Server",
    }));

// List and use tools
IList<McpClientTool> tools = await mcpClient.ListToolsAsync();

List<ChatMessage> messages = [];
messages.Add(new(ChatRole.User, "Use the weather tool for Seattle"));

await foreach (var update in client.GetStreamingResponseAsync(
    messages, new() { Tools = [.. tools] }))
{
    Console.Write(update);
}
```

## Azure MCP Server

```csharp
var mcpClient = await McpClient.CreateAsync(
    new StdioClientTransport(new()
    {
        Command = "npx",
        Arguments = ["-y", "@azure/mcp@latest", "server", "start"],
        Name = "Azure MCP",
    }));

var tools = await mcpClient.ListToolsAsync();
// Access Azure Storage, Cosmos DB, etc.
```

## MCP with Azure AI Foundry Agents

```csharp
using Azure.AI.Agents.Persistent;

PersistentAgentsClient agentClient = new(projectEndpoint, new DefaultAzureCredential());

// Create MCP tool definition
MCPToolDefinition mcpTool = new(
    mcpServerLabel: "my-server",
    mcpServerUrl: "https://my-mcp-server.example.com");
mcpTool.AllowedTools.Add("search_docs");

// Create agent with MCP
PersistentAgent agent = agentClient.Administration.CreateAgent(
    model: "gpt-4o-mini",
    name: "mcp-agent",
    instructions: "Use MCP tools to help users.",
    tools: [mcpTool]);

// Run with tool resources
PersistentAgentThread thread = agentClient.Threads.CreateThread();
agentClient.Messages.CreateMessage(thread.Id, MessageRole.User, "Search docs");

MCPToolResource resource = new(mcpServerLabel);
resource.UpdateHeader("Authorization", "Bearer <token>");

ThreadRun run = agentClient.Runs.CreateRun(thread, agent, resource.ToToolResources());

// Handle approvals
while (run.Status == RunStatus.RequiresAction)
{
    if (run.RequiredAction is SubmitToolApprovalAction approval)
    {
        var approvals = approval.SubmitToolApproval.ToolCalls
            .OfType<RequiredMcpToolCall>()
            .Select(c => new ToolApproval(c.Id, approve: true))
            .ToList();
        
        run = agentClient.Runs.SubmitToolOutputsToRun(
            thread.Id, run.Id, toolApprovals: approvals);
    }
    Thread.Sleep(1000);
    run = agentClient.Runs.GetRun(thread.Id, run.Id);
}
```
