using System;

namespace Payments;

public class CardGateway : PaymentGateway
{
    private string maskedPan;

    public string MaskedPan
    {
        get => maskedPan;
        set
        {
            if (string.IsNullOrWhiteSpace(value))
                throw new ArgumentException("MaskedPan не может быть пустым");
            maskedPan = value;
        }
    }

    public CardGateway(string provider) : base(provider) { }

    public void SetMaskedPan(string pan)
    {
        if (string.IsNullOrWhiteSpace(pan) || pan.Length < 4)
            throw new ArgumentException("PAN слишком короткий");
        string last4 = pan.Substring(pan.Length - 4);
        MaskedPan = $"**** **** **** {last4}";
    }

    public override string Process(decimal amount) =>
        $"Обработано {amount} через карту {MaskedPan}";
}
