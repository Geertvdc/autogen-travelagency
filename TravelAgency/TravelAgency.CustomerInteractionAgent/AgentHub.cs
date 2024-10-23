using Microsoft.AspNetCore.SignalR;
using System.Threading.Tasks;

namespace TravelAgency.CustomerInteractionAgent
{
    public class AgentHub : Hub
    {
        public async Task SendMessage(string user, string message)
        {
            await Clients.All.SendAsync("ReceiveMessage", user, message);
        }
    }
}