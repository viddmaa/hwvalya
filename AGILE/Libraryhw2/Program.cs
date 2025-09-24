using LibraryProject;
using System;


class Program
{
    static void Main(string[] args)
    {
        var author1 = new Author("Фёдор Михайлович Достоевский", "Русский писатель, философ.");
        author1.AddWork("Преступление и наказание");
        author1.AddWork("Идиот");

        var author2 = new Author("Николай Васильевич Гоголь", "Прозаик и драматург.");
        author2.AddWork("Мертвые души");
        author2.AddWork("Шинель");

        var pub1 = new Publication("978-5-04-116676-2", "роман", author1);
        var pub2 = new Publication("978-5-17-063256-5 ", "роман", author1);
        var pub3 = new Publication("978-5-389-04731-0", "роман-поэма", author2);
        var pub4 = new Publication("978-5-9951-5175-3", "повесть", author2);

        var lib = new Library("Библиотека №7", "ул. Пушистая, 7");
        lib.AddPublication(pub1);
        lib.AddPublication(pub2);
        lib.AddPublication(pub3);
        lib.AddPublication(pub4);

        Console.WriteLine(lib);
        Console.WriteLine("\nИздания:");
        foreach (var pub in lib.Publications)
            Console.WriteLine("- " + pub);

        var found = lib.FindPublication("978-5-04-116676-2");
        if (found != null)
            Console.WriteLine($"\nНайдено: {found}");

        Console.WriteLine("\nАвторы:");
        foreach (var au in lib.GetAuthors())
            Console.WriteLine("- " + au);

        lib.RemovePublication("978-5-9951-5175-3");
        Console.WriteLine("\nПосле удаления одного издания:");
        Console.WriteLine(lib);
    }
}
