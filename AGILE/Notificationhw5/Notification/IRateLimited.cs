using System;

namespace Notification
{
    public interface IRateLimited
    {
        int PerMinuteLimit { get; set; }
        bool TryConsume();
    }
}