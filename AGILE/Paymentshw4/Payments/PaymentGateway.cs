using System;

namespace Payments;

public class PaymentGateway
{
    private string providerName;
    private bool sandbox;

    public string ProviderName
    {
        get => providerName;
        set
        {
            if (string.IsNullOrWhiteSpace(value))
                throw new ArgumentException("ProviderName не может быть пустым");
            providerName = value;
        }
    }

    public bool Sandbox
    {
        get => sandbox;
        set => sandbox = value;
    }

    public PaymentGateway(string provider, bool sandbox = false)
    {
        ProviderName = provider;
        Sandbox = sandbox;
    }

    public void EnableSandbox(bool on) => Sandbox = on;

    public string Info() => $"Provider: {ProviderName}, Mode: {(Sandbox ? "SANDBOX" : "LIVE")}";

    public virtual string Process(decimal amount) =>
         $"Обработано {amount} через базовый шлюз";
}
