using System;

namespace Notification
{
    public interface INotification
    {
        string Message { get; set; }
        bool Sent { get; set; }

        void Send()
        {
            Console.WriteLine($"Отправлено сообщение: {Message}");
            Sent = true;
        }
    }
}