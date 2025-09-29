using Payments;

class Program
{
    static void Main()
    {
        var observer = new GatewayObserver();

        var baseGw = new PaymentGateway("БазовыйПровайдер");
        observer.PrintInfo(baseGw, 10);

        var card = new CardGateway("Visa");
        card.SetMaskedPan("1234567812345678");
        observer.PrintInfo(card, 500);

        var wallet = new WalletGateway("PayPal", "user123");
        observer.PrintInfo(wallet, 200);

        var crypto = new CryptoWallet("ChainPay", "abc123", "BTC");
        crypto.SwitchNetwork("ETH");
        observer.PrintInfo(crypto, 0.05m);
    }
}
