using Microsoft.AutoGen.Agents;
using Microsoft.AutoGen.Extensions.SemanticKernel;
using TravelAgency.AIAgents.TravelManager;

var builder = WebApplication.CreateBuilder(args);

builder.AddServiceDefaults();
builder.ConfigureSemanticKernel();

builder.AddAgentWorker(builder.Configuration["AGENT_HOST"]!)
    .AddAgent<TravelManager>(nameof(TravelManager));

builder.Services.AddSingleton<AgentClient>();

var app = builder.Build();

app.MapDefaultEndpoints();

app.Run();