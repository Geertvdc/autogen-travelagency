using System.Net;
using Orleans.Hosting;
using Orleans.Configuration;

var builder = DistributedApplication.CreateBuilder(args);

var qdrant = builder.AddQdrant("qdrant");

var orleans = builder.AddOrleans("orleans")
    .WithDevelopmentClustering();

var agentHost = builder.AddProject<Projects.TravelAgency_AgentHost>("agenthost")
    .WithReference(orleans);
 var agentHostHttps = agentHost.GetEndpoint("https");

 builder.AddProject<Projects.TravelAgency_CustomerInteractionAgent>("customer-interaction-agent")
     .WithEnvironment("AGENT_HOST", $"{agentHostHttps.Property(EndpointProperty.Url)}");

 builder.AddProject<Projects.TravelAgency_AIAgents>("ai-agents")
     .WithEnvironment("AGENT_HOST", $"{agentHostHttps.Property(EndpointProperty.Url)}")
     .WithEnvironment("Qdrant__Endpoint", $"{qdrant.Resource.HttpEndpoint.Property(EndpointProperty.Url)}")
     .WithEnvironment("Qdrant__ApiKey", $"{qdrant.Resource.ApiKeyParameter.Value}")
     .WithEnvironment("Qdrant__VectorSize", "1536")
     .WithEnvironment("OpenAI__Key", builder.Configuration["OpenAI:Key"])
     .WithEnvironment("OpenAI__Endpoint", builder.Configuration["OpenAI:Endpoint"]);

builder.Build().Run();