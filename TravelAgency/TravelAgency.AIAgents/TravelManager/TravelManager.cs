using Microsoft.AutoGen.Abstractions;
using Microsoft.AutoGen.Agents;
using Microsoft.SemanticKernel;
using Microsoft.SemanticKernel.Memory;
using TravelAgency.AIAgents.State;
using TravelAgency.Contracts.Messages;

namespace TravelAgency.AIAgents.TravelManager;

#pragma warning disable SKEXP0001

[TopicSubscription("travelagency")]
public class TravelManager(IAgentContext context, Kernel kernel, ISemanticTextMemory memory, [FromKeyedServices("EventTypes")] EventTypes typeRegistry, ILogger<TravelManager> logger)
#pragma warning restore SKEXP0001
    : AiAgent<TravelManagerState>(context, memory, kernel, typeRegistry),
        IHandle<UserMessage>
{
    public async Task Handle(UserMessage message)
    {
        var advice = await CreateTravelAdvise(message.Message);
        var evt = new TravelAdvice
        {
            Description = advice
        }.ToCloudEvent(this.AgentId.Key);
        await PublishEvent(evt);
    }
    
    public async Task<string> CreateTravelAdvise(string ask)
    {
        try
        {
            var context = new KernelArguments { ["input"] = AppendChatHistory(ask) };
            // var instruction = "Consider the following architectural guidelines:!waf!";
            // var enhancedContext = await AddKnowledge(instruction, "waf", context);
            return await CallFunction(TravelManagerSkills.CreateHolidayAdvice, context);
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "Error creating readme");
            return "";
        }
    }
}