using System;

namespace CloudStorageRetrieval
{
    public abstract class StorageTier
    {
        private readonly int _baseCost;

        protected StorageTier(int baseCost)
        {
            if (baseCost < ModifierHelper.MinCost)
                throw new ArgumentOutOfRangeException(nameof(baseCost));
            _baseCost = baseCost;
        }

        public int BaseCost => _baseCost;

        public virtual int GetRetrievalCost(StorageContext ctx)
        {
            if (ctx == null) throw new ArgumentNullException(nameof(ctx));
            return ModifierHelper.Apply(BaseCost, ctx, ignoreModifiers: false);
        }
    }
}
