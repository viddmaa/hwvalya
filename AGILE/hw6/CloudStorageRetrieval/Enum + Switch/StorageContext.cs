using System;

namespace CloudStorageRetrieval
{
    public sealed class StorageContext
    {
        public bool IsExpedited { get; }
        public bool IsCrossRegion { get; }
        public bool HasWeekendMaintenance { get; }

        public StorageContext(bool isExpedited = false,
                              bool isCrossRegion = false,
                              bool hasWeekendMaintenance = false)
        {
            IsExpedited = isExpedited;
            IsCrossRegion = isCrossRegion;
            HasWeekendMaintenance = hasWeekendMaintenance;
        }
    }
}
