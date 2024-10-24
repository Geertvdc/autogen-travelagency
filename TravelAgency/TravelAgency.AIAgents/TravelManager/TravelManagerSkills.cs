namespace TravelAgency.AIAgents.TravelManager;

public static class TravelManagerSkills
{
    public const string CreateHolidayAdvice = """
                                              You are a manager of a travel agency. 
                                              Please create a holiday package based on the input below. The input will contain a description of what the customer is looking for in a holiday.
                                              Based on the input you decide a nice location, transport to it, accommodation and activities.
                                              --
                                              Input: {{$input}}
                                              """;
}
