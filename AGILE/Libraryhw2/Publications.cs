namespace LibraryProject;

public class Publication
{
    public string Isbn { get; private set; }
    public string Genre { get; private set; }
    public Author Author { get; private set; }

    public Publication(string isbn, string genre, Author author)
    {
        Isbn = isbn;
        Genre = genre;
        Author = author;
    }

    public override string ToString()
    {
        return $"ISBN: {Isbn}, жанр: {Genre}, автор: {Author.FullName}";
    }
}
