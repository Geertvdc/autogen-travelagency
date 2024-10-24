using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.SignalR.Client;
using Microsoft.AutoGen.Abstractions;
using Microsoft.AutoGen.Agents;
using TravelAgency.Contracts.Messages;

namespace TravelAgency.CustomerInteractionAgent.Components.Pages;

public partial class Agent: ComponentBase
{
    private string NewEventText { get; set; } = "";
    private List<string> Events { get; set; } = new List<string>();
    
    [Inject]
    private NavigationManager NavigationManager { get; set; }
    
    [Inject]
    private AgentClient _client { get; set; }
    
    protected override async Task OnInitializedAsync()
    {
        var connection = new HubConnectionBuilder()
            .WithUrl(NavigationManager.ToAbsoluteUri("/agentHub"))
            .Build();

        connection.On<string, string>("ReceiveMessage", (user, message) =>
        {
            Events.Add($"{user}: {message}");
            InvokeAsync(StateHasChanged);
        });

        await connection.StartAsync();
    }

    private async Task AddEvent()
    {
        var message = new UserMessage { Message = NewEventText };
        
        var cloudevent = message.ToCloudEvent("CustomerInteractionAgentUI");
        await _client.PublishEventAsync(cloudevent);
        
        
        //Events.Add($"You: {NewEventText}");
        NewEventText = string.Empty;
    }
}