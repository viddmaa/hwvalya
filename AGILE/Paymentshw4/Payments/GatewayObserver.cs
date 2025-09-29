using System;

namespace Payments;

public class GatewayObserver
{
    public void PrintInfo(PaymentGateway gateway, decimal amount)
    {
        Console.WriteLine(
            $"[{gateway.ProviderName}] {gateway.Process(amount)}"
        );
    }
}
