using System;
using System.Collections;


public class Bestiary : IEnumerable<Monster>
{
    private readonly List<Monster> _monsters = new List<Monster>();
    private readonly Dictionary<string, Monster> _byId = new Dictionary<string, Monster>();

    public int Count => _monsters.Count;

    public Monster this[int index]
    {
        get
        {
            if (index < 0 || index >= _monsters.Count)
                throw new ArgumentOutOfRangeException(nameof(index));
            return _monsters[index];
        }
    }

    public Monster this[string id]
    {
        get
        {
            if (id == null)
                throw new ArgumentNullException(nameof(id));
            if (!_byId.TryGetValue(id, out Monster? monster))
                throw new KeyNotFoundException();
            return monster;
        }
    }

    public void Add(Monster monster)
    {
        if (monster == null)
            throw new ArgumentNullException(nameof(monster));
        if (_byId.ContainsKey(monster.Id))
            throw new ArgumentException("Duplicate Id");

        _monsters.Add(monster);
        _byId.Add(monster.Id, monster);
    }

    public bool RemoveAt(int index)
    {
        if (index < 0 || index >= _monsters.Count)
            return false;

        var monster = _monsters[index];
        _monsters.RemoveAt(index);
        _byId.Remove(monster.Id);
        return true;
    }

    public bool RemoveById(string id)
    {
        if (id == null || !_byId.ContainsKey(id))
            return false;

        var monster = _byId[id];
        _byId.Remove(id);
        _monsters.Remove(monster);
        return true;
    }

    public IEnumerable<Monster> EnumerateByThreat(ThreatLevel minThreat)
    {
        foreach (var monster in _monsters)
        {
            if (monster.Threat >= minThreat)
                yield return monster;
        }
    }

    public IEnumerator<Monster> GetEnumerator() => _monsters.GetEnumerator();
    IEnumerator IEnumerable.GetEnumerator() => GetEnumerator();
}