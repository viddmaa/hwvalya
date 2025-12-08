using System;


public class Monster
{
    private readonly List<Ability> _abilities = new List<Ability>();

    public string Id { get; }
    public string Name { get; }
    public ThreatLevel Threat { get; }
    public IReadOnlyList<Ability> Abilities => _abilities.AsReadOnly();

    public Monster(string id, string name, ThreatLevel threat)
    {
        if (string.IsNullOrWhiteSpace(id))
            throw new ArgumentException("Id cannot be null or whitespace");
        
        Id = id;
        Name = name;
        Threat = threat;
    }

    public void AddAbility(Ability ability)
    {
        if (ability == null)
            throw new ArgumentNullException(nameof(ability));
        _abilities.Add(ability);
    }

    public override string ToString()
    {
        return $"{Name} (ID: {Id}, Threat: {Threat})";
    }
}