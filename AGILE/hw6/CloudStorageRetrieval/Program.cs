using System;

namespace CloudStorageRetrieval
{
    public static class Program
    {
        public static void Main()
        {
            var empty = new StorageContext();
            var expedited = new StorageContext(isExpedited: true);
            var cross = new StorageContext(isCrossRegion: true);
            var weekend = new StorageContext(hasWeekendMaintenance: true);

            // Enum 
            Console.WriteLine(RetrievalCostCalculatorEnum.Calculate(StorageClass.Standard, empty));
            Console.WriteLine(RetrievalCostCalculatorEnum.Calculate(StorageClass.InfrequentAccess, empty)); 
            Console.WriteLine(RetrievalCostCalculatorEnum.Calculate(StorageClass.Archive, empty));
            Console.WriteLine(RetrievalCostCalculatorEnum.Calculate(StorageClass.DeepArchive, empty));
            Console.WriteLine(RetrievalCostCalculatorEnum.Calculate(StorageClass.ArchiveInstant, empty)); 

            // OOP 
            Console.WriteLine(RetrievalCostCalculatorOop.Calculate(new Standard(), empty));
            Console.WriteLine(RetrievalCostCalculatorOop.Calculate(new InfrequentAccess(), empty)); 
            Console.WriteLine(RetrievalCostCalculatorOop.Calculate(new Archive(), empty)); 
            Console.WriteLine(RetrievalCostCalculatorOop.Calculate(new DeepArchive(), empty));
            Console.WriteLine(RetrievalCostCalculatorOop.Calculate(new ArchiveInstant(), empty)); 
        }
    }
}
