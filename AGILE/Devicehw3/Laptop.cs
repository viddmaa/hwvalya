namespace Device;

public class Laptop : Device
{
    public string Processor_Perfomance { get; set; }

    public Laptop(string brand, int batteryCapacity, string processorPerfomance)
        : base(brand, batteryCapacity)
    {
        Processor_Perfomance = processorPerfomance;
    }
    
    public virtual void ShowDeviceInfo()
    {
        Console.WriteLine($"Ноутбук: Бренд = {Brand}, Емкость акуммулятора = {BatteryCapacity} мАч, " +
        $"Производительность процессора = {Processor_Perfomance}");
    }

    public override string ToString()
    {
        return $"Ноутбук: Бренд = {Brand}, Емкость акуммулятора = {BatteryCapacity} мАч, " +
        $"Производительность процессора = {Processor_Perfomance}";
    }
}