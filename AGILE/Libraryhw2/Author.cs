using System.Collections.Generic;
namespace LibraryProject;

public class Author
{
    public string FullName { get; private set; }
    public string Bio { get; private set; }
    public List<string> Works { get; private set; }

    public Author(string fullName, string bio)
    {
        FullName = fullName;
        Bio = bio;
        Works = new List<string>();
    }

    public void AddWork(string workTitle)
    {
        if (!string.IsNullOrWhiteSpace(workTitle))
            Works.Add(workTitle);
    }

    public void RemoveWork(string workTitle)
    {
        Works.Remove(workTitle);
    }

    public int GetWorksCount()
    {
        return Works.Count;
    }

    public override string ToString()
    {
        return $"{FullName} (произведений: {Works.Count})";
    }
}
