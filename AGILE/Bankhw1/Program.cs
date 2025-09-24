class Program
{
    static void Main()
    {
        BankAccount acc = new BankAccount("Валентина Холод", "40923480239471074580", 6500);

        Console.WriteLine(acc);

        acc.Deposit(1500);
        acc.Withdraw(2000);
        acc.Deposit(10000);
        acc.Withdraw(17000);

        Console.WriteLine(acc);
    }
}
