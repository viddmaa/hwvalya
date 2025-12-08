using System;

public class Ability
{
    public string Code { get; }
    public int Power { get; }
    public int CooldownSeconds { get; }

    public Ability(string code, int power, int cooldownSeconds = 0)
    {
        if (string.IsNullOrWhiteSpace(code))
            throw new ArgumentException("Code cannot be null or whitespace");

        Code = code;
        Power = power;
        CooldownSeconds = cooldownSeconds;
    }
    
    public override string ToString()
    {
        return $"{Code} (Power: {Power})";
    }
}