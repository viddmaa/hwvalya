using System;

namespace Notification
{
    internal class Program
    {
        private const int DefaultLmit = 2;
        static void Main()
        {
            Console.WriteLine("Тест PlainNotification");
            INotification plain = new PlainNotification
            {
                Message = "Привет от обычного!"
            };
            
            plain.Send();
            Console.WriteLine($"Sent = {plain.Sent}\n");

            Console.WriteLine("Тест ThrottledNotification");
            var throttled = new ThrottledNotification
            {
                Message = "Привет с лимитом!",
                PerMinuteLimit = 2
            };

            for (int i = 1; i <= 3; i++)
            {
                Console.WriteLine($"Попытка {i}:");
                throttled.Send();
                Console.WriteLine($"Sent = {throttled.Sent}, " +
                                  $"Использовано {throttled.UsedInCurrentMinute}/" +
                                  $"{throttled.PerMinuteLimit}\n");
            }

            throttled.ResetWindow();
            throttled.Send();
            Console.WriteLine($"Sent после сброса = {throttled.Sent}");
        }
    }
}