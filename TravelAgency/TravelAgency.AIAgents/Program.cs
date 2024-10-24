using Microsoft.AutoGen.Agents;
using Microsoft.AutoGen.Extensions.SemanticKernel;
using TravelAgency.AIAgents.TravelManager;

var builder = WebApplication.CreateBuilder(args);

builder.AddServiceDefaults();

builder.ConfigureSemanticKernel();

builder.AddAgentWorker(builder.Configuration["AGENT_HOST"]!)
    .AddAgent<TravelManager>(nameof(TravelManager));

var app = builder.Build();

app.MapDefaultEndpoints();

app.Run();