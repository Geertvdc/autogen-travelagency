using System.Diagnostics.CodeAnalysis;
using Microsoft.AspNetCore.SignalR;
using Microsoft.AutoGen.Abstractions;
using Microsoft.AutoGen.Agents;
using Microsoft.SemanticKernel;
using Microsoft.SemanticKernel.Memory;
using System.Threading.Tasks;
using TravelAgency.Contracts.Messages;

#pragma warning disable SKEXP0001

namespace TravelAgency.CustomerInteractionAgent.Agents
{
    public class WebUserAgent(
        IAgentContext context,
        [FromKeyedServices("EventTypes")] EventTypes typeRegistry,
        IHubContext<AgentHub> hubContext
    ) : IOAgent<AgentState>(context, typeRegistry), IHandle<TravelAdvice>
    {
        private readonly IHubContext<AgentHub> _hubContext = hubContext;
        
        public async Task Handle(TravelAdvice item)
        {
            // Handle the message and send it to the client via SignalR
            await _hubContext.Clients.All.SendAsync("ReceiveMessage", "Agent", item.Description);
        }

        public override Task<string> ProcessInput(string message)
        {
            // Implement your input processing logic here
            return Task.FromResult(message);
        }

        public override Task ProcessOutput(string message)
        {
            // Implement your output processing logic here
            return Task.CompletedTask;
        }
    }
}