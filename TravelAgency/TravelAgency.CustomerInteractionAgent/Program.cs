using Microsoft.AutoGen.Agents;
using Microsoft.AutoGen.Extensions.SemanticKernel;
using TravelAgency.CustomerInteractionAgent;
using TravelAgency.CustomerInteractionAgent.Agents;
using App = TravelAgency.CustomerInteractionAgent.Components.App;

var builder = WebApplication.CreateBuilder(args);

builder.AddServiceDefaults();
builder.ConfigureSemanticKernel();

builder.AddAgentWorker(builder.Configuration["AGENT_HOST"]!)
    .AddAgent<WebUserAgent>(nameof(WebUserAgent));

builder.Services.AddSingleton<AgentClient>();

// Add services to the container.
builder.Services.AddRazorComponents()
    .AddInteractiveServerComponents();
builder.Services.AddSignalR();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Error", createScopeForErrors: true);
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();
}

app.UseHttpsRedirection();

app.UseRouting();

app.UseStaticFiles();
app.UseAntiforgery();

app.MapRazorComponents<App>()
    .AddInteractiveServerRenderMode();

app.MapHub<AgentHub>("/agentHub");

app.Run();