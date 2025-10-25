using System;

namespace Notification
{
    public class ThrottledNotification : INotification, IRateLimited
    {
        private string message = "";
        private bool sent;
        private int perMinuteLimit;
        private int usedInCurrentMinute;

        public string Message
        {
            get => message;
            set => message = value;
        }

        public bool Sent
        {
            get => sent;
            set => sent = value;
        }

        public int PerMinuteLimit
        {
            get => perMinuteLimit;
            set => perMinuteLimit = value;
        }

        public int UsedInCurrentMinute
        {
            get => usedInCurrentMinute;
            private set => usedInCurrentMinute = value;
        }

        public bool TryConsume()
        {
            if (UsedInCurrentMinute < PerMinuteLimit)
            {
                UsedInCurrentMinute++;
                return true;
            }
            return false;
        }

        public void ResetWindow()
        {
            UsedInCurrentMinute = 0;
            Console.WriteLine("Окно лимита сброшено!");
        }

        public void Send()
        {
            if (TryConsume())
            {
                Console.WriteLine($"Отправлено сообщение: {Message}");
                Sent = true;
            }
            else
            {
                Console.WriteLine("Лимит отправок превышен!");
                Sent = false;
            }
        }
    }
}