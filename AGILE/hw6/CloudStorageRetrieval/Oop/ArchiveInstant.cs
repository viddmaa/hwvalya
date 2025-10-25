namespace CloudStorageRetrieval
{
    public sealed class ArchiveInstant : StorageTier
    {
        public ArchiveInstant() : base(5) { }

        public override int GetRetrievalCost(StorageContext ctx)
        {
            if (ctx == null) throw new System.ArgumentNullException(nameof(ctx));
            return BaseCost;
        }
    }
}
