namespace CloudStorageRetrieval
{
    internal static class ModifierHelper
    {
        public const int Expedited = 3;
        public const int CrossRegion = 1;
        public const int Weekend = -1;
        public const int MinCost = 1;

        public static int Apply(int baseCost, StorageContext ctx, bool ignoreModifiers = false)
        {
            if (ignoreModifiers) return baseCost;

            var r = baseCost;
            if (ctx.IsExpedited) r += Expedited;
            if (ctx.IsCrossRegion) r += CrossRegion;
            if (ctx.HasWeekendMaintenance) r += Weekend;
            return r < MinCost ? MinCost : r;
        }
    }
}
