using System;

namespace Payments;

public class CryptoWallet : WalletGateway
{
    private string network;

    public string Network
    {
        get => network;
        set
        {
            if (string.IsNullOrWhiteSpace(value))
                throw new ArgumentException("Network не может быть пустым");
            network = value.ToUpper();
        }
    }

    public CryptoWallet(string provider, string id, string network)
        : base(provider, id)
    {
        Network = network;
    }

    public void SwitchNetwork(string n) => Network = n;

    public override string Process(decimal amount) =>
         $"Обработано {amount} через {Network}-кошелёк {WalletId}";
}
