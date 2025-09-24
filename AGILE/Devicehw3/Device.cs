namespace Device;

public class Device
{
    public string Brand { get; set; }
    public int BatteryCapacity { get; set; }

    public Device(string brand, int batteryCapacity)
    {
        Brand = brand;
        BatteryCapacity = batteryCapacity;
    }

    public virtual void Show_Device_Info()
    {
        Console.WriteLine($"Device: Бренд = {Brand}, Емкость акуммулятора = {BatteryCapacity} мАч");
    }

    public override string ToString()
    {
        return ($"Device: Бренд = {Brand}, Емкость акуммулятора = {BatteryCapacity} мАч");
    }
}