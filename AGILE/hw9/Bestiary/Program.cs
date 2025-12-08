using System;

public class Program
{
    public static void Main()
    {
        var bestiary = new Bestiary();

        var goblin = new Monster("goblin_01", "Goblin Scout", ThreatLevel.Minor);
        goblin.AddAbility(new Ability("stab", 5, 2));

        var dragon = new Monster("dragon_01", "Ancient Dragon", ThreatLevel.Mythic);
        dragon.AddAbility(new Ability("fire_breath", 50, 10));

        bestiary.Add(goblin);
        bestiary.Add(dragon);

        Console.WriteLine($"Count: {bestiary.Count}");
        Console.WriteLine($"By index: {bestiary[0]}");
        Console.WriteLine($"By id: {bestiary["dragon_01"]}");

        foreach (var monster in bestiary.EnumerateByThreat(ThreatLevel.Severe))
        {
            Console.WriteLine($"Threat monster: {monster}");
        }

        bestiary.RemoveAt(0);
        Console.WriteLine($"After remove: {bestiary.Count}");
    }
}