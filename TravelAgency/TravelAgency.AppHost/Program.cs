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

// builder.AddProject<Projects.TravelAgency_CustomerInteractionAgent>("customer-interaction-agent")
//     .WithEnvironment("AGENT_HOST", $"{agentHostHttps.Property(EndpointProperty.Url)}");

 builder.AddProject<Projects.TravelAgency_CustomerInteractionAgent>("customer-interaction-agent")
     .WithEnvironment("AGENT_HOST", $"https://localhost:7157")
     .WithEnvironment("Qdrant__Endpoint", $"{qdrant.Resource.HttpEndpoint.Property(EndpointProperty.Url)}")
     .WithEnvironment("Qdrant__ApiKey", $"{qdrant.Resource.ApiKeyParameter.Value}");

builder.Build().Run();