using System;

namespace CloudStorageRetrieval
{
    public static class RetrievalCostCalculatorEnum
    {
        public static int Calculate(StorageClass sc, StorageContext ctx)
        {
            if (ctx == null) throw new ArgumentNullException(nameof(ctx));

            var baseCost = sc switch
            {
                StorageClass.Standard => 1,
                StorageClass.InfrequentAccess => 2,
                StorageClass.Archive => 4,
                StorageClass.DeepArchive => 6,
                StorageClass.ArchiveInstant => 5,
                _ => throw new ArgumentOutOfRangeException(nameof(sc))
            };

            var ignoreMods = sc == StorageClass.ArchiveInstant;
            return ModifierHelper.Apply(baseCost, ctx, ignoreMods);
        }
    }
}
