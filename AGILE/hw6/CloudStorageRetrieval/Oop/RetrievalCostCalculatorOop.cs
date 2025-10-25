using System;

namespace CloudStorageRetrieval
{
    public static class RetrievalCostCalculatorOop
    {
        public static int Calculate(StorageTier tier, StorageContext ctx)
        {
            if (tier == null) throw new ArgumentNullException(nameof(tier));
            if (ctx == null) throw new ArgumentNullException(nameof(ctx));
            return tier.GetRetrievalCost(ctx);
        }
    }
}
