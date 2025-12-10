# Orchestrations - C#

Multi-agent workflow patterns for coordinating multiple agents.

```bash
dotnet add package Microsoft.Agents.Workflows --prerelease
```

## Sequential

Agents process in order, passing results forward:

```csharp
using Microsoft.Agents.Workflows;

var translator = chatClient.CreateAIAgent(instructions: "Translate to French.");
var summarizer = chatClient.CreateAIAgent(instructions: "Summarize in 2 sentences.");

var workflow = AgentWorkflowBuilder.BuildSequential([translator, summarizer]);

var messages = new List<ChatMessage> { new(ChatRole.User, "Hello world!") };
StreamingRun run = await InProcessExecution.StreamAsync(workflow, messages);
await run.TrySendMessageAsync(new TurnToken(emitEvents: true));

await foreach (WorkflowEvent evt in run.WatchStreamAsync())
{
    if (evt is AgentRunUpdateEvent e)
        Console.WriteLine($"{e.ExecutorId}: {e.Data}");
    else if (evt is WorkflowCompletedEvent completed)
    {
        var result = (List<ChatMessage>)completed.Data!;
        break;
    }
}
```

## Concurrent

Agents work in parallel on the same input:

```csharp
var french = chatClient.CreateAIAgent(instructions: "Translate to French.");
var spanish = chatClient.CreateAIAgent(instructions: "Translate to Spanish.");
var german = chatClient.CreateAIAgent(instructions: "Translate to German.");

var workflow = AgentWorkflowBuilder.BuildConcurrent([french, spanish, german]);

// All agents run simultaneously, results aggregated
```

## Group Chat

Collaborative conversation with manager-controlled speaker selection:

```csharp
var writer = chatClient.CreateAIAgent(name: "Writer",
    instructions: "Write creative copy. Keep under 50 words.");
var reviewer = chatClient.CreateAIAgent(name: "Reviewer",
    instructions: "Review copy. Say 'APPROVED' when satisfied.");

var workflow = AgentWorkflowBuilder
    .CreateGroupChatBuilderWith(agents => 
        new RoundRobinGroupChatManager(agents) { MaximumIterationCount = 6 })
    .AddParticipants(writer, reviewer)
    .Build();
```

### Custom Termination

```csharp
public class ApprovalManager : RoundRobinGroupChatManager
{
    private readonly string _approver;
    public ApprovalManager(IReadOnlyList<AIAgent> agents, string approver) 
        : base(agents) => _approver = approver;

    protected override ValueTask<bool> ShouldTerminateAsync(
        IReadOnlyList<ChatMessage> history, CancellationToken ct = default)
    {
        var last = history.LastOrDefault();
        return ValueTask.FromResult(
            last?.AuthorName == _approver &&
            last.Text?.Contains("APPROVED", StringComparison.OrdinalIgnoreCase) == true);
    }
}
```

## Handoff

Dynamic agent switching based on conditions:

```csharp
var triage = chatClient.CreateAIAgent(name: "Triage",
    instructions: "Route: HANDOFF:Billing or HANDOFF:Technical");
var billing = chatClient.CreateAIAgent(name: "Billing",
    instructions: "Handle billing inquiries.");
var technical = chatClient.CreateAIAgent(name: "Technical",
    instructions: "Provide technical support.");

var workflow = AgentWorkflowBuilder
    .CreateHandoffBuilder(triage)
    .AddHandoffTarget(triage, billing, 
        condition: msg => msg.Text?.Contains("HANDOFF:Billing") == true)
    .AddHandoffTarget(triage, technical, 
        condition: msg => msg.Text?.Contains("HANDOFF:Technical") == true)
    .Build();
```

## Custom Workflow

```csharp
WorkflowBuilder builder = new(agentA);
builder.AddEdge(agentA, agentB);
builder.AddEdge<ChatMessage>(agentB, agentC,
    condition: msg => msg.Text?.Contains("continue") == true);
builder.WithOutputFrom(agentB, agentC);
var workflow = builder.Build();
```

## Durable Orchestrations (Azure Functions)

Fault-tolerant, long-running workflows:

```csharp
using Microsoft.Agents.AI.DurableTask;
using Microsoft.DurableTask;

[Function("agent_orchestration")]
public static async Task<Dictionary<string, string>> Orchestrate(
    [OrchestrationTrigger] TaskOrchestrationContext context)
{
    var input = context.GetInput<string>()!;

    // Sequential
    DurableAIAgent main = context.GetAgent("MainAgent");
    var mainResult = await main.RunAsync<TextResponse>(input);

    // Fan-out (parallel)
    DurableAIAgent french = context.GetAgent("FrenchTranslator");
    DurableAIAgent spanish = context.GetAgent("SpanishTranslator");
    
    var frenchTask = french.RunAsync<TextResponse>(mainResult.Result.Text);
    var spanishTask = spanish.RunAsync<TextResponse>(mainResult.Result.Text);
    
    // Fan-in
    await Task.WhenAll(frenchTask, spanishTask);

    return new()
    {
        ["original"] = mainResult.Result.Text,
        ["french"] = (await frenchTask).Result.Text,
        ["spanish"] = (await spanishTask).Result.Text
    };
}
```
