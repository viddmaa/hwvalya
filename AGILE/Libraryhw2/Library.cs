using System.Collections.Generic;

namespace LibraryProject;

public class Library
{
    public string Name { get; private set; }
    public string Location { get; private set; }
    public List<Publication> Publications { get; private set; }

    public Library(string name, string location)
    {
        Name = name;
        Location = location;
        Publications = new List<Publication>();
    }

    public void AddPublication(Publication p)
    {
        Publications.Add(p);
    }

    public void RemovePublication(string isbn)
    {
        for (int i = Publications.Count - 1; i >= 0; i--)
            if (Publications[i].Isbn == isbn)
                Publications.RemoveAt(i);
    }

    public Publication? FindPublication(string isbn)
    {
        foreach (var p in Publications)
            if (p.Isbn == isbn)
                return p;
        return null;
    }

    public int GetPublicationsCount()
    {
        return Publications.Count;
    }

    public List<Author> GetAuthors()
    {
        var authors = new List<Author>();
        foreach (var p in Publications)
        {
            if (!authors.Contains(p.Author))
                authors.Add(p.Author);
        }
        return authors;
    }

    public override string ToString()
    {
        return $"Библиотека '{Name}' ({Location}), изданий: {Publications.Count}";
    }
}
