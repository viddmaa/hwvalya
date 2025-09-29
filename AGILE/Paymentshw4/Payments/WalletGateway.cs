using System;

namespace Payments;

public class WalletGateway : PaymentGateway
{
    private string walletId;

    public string WalletId
    {
        get => walletId;
        set
        {
            if (string.IsNullOrWhiteSpace(value))
                throw new ArgumentException("WalletId не может быть пустым");
            walletId = value;
        }
    }

    public WalletGateway(string provider, string id) : base(provider)
    {
        WalletId = id;
    }

    public void Link(string id) => WalletId = id;
}
