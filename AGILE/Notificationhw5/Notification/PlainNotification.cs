using System;

namespace Notification
{
    public class PlainNotification : INotification
    {
        private string message = "";
        private bool sent;

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
    }
}