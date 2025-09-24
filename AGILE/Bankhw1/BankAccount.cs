class BankAccount
{
    public string Owner { get; init; }
    public string Number { get; private set; }
    public decimal Balance { get; private set; }

    public BankAccount(string owner, string number, decimal balance)
    {
        Owner = owner;
        Number = number;
        Balance = balance;
    }

    public void Deposit(decimal amount)
    {
        Balance += amount;
        Console.WriteLine($"Счет {Number} пополнен на {amount} руб. Баланс: {Balance} руб. ");
    }

    public void Withdraw(decimal amount)
    {
        if (amount > Balance)
        {
            Console.WriteLine($"Недостаточно средств. Баланс: {Balance} руб.");
        }
        else
        {
            Balance -= amount;
            Console.WriteLine($"Со счета {Number} снято {amount} руб. Баланс: {Balance} руб.");
        }
    }

    public override string ToString()
    {
        return $"Владелец: {Owner}, Счет: {Number}, Баланс: {Balance} руб.";
    }
}