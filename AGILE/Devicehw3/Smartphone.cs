namespace Device;

public class Smartphone : Device
{
    public string Screen_Resolution { get; set; }

    public Smartphone(string brand, int batteryCapacity, string screen_Resolution)
        : base(brand, batteryCapacity)
    {
        Screen_Resolution = screen_Resolution;
    }

    public virtual void ShowDeviceInfo()
    {
        Console.WriteLine($"Смартфон: Бренд = {Brand}, Емкость акуммулятора = {BatteryCapacity} мАч, " +
        $"Разрешение экрана = {Screen_Resolution}");
    }

    public override string ToString()
    {
        return $"Смартфон: Бренд = {Brand}, Емкость акуммулятора = {BatteryCapacity} мАч, " +
        $"Разрешение экрана = {Screen_Resolution}";
    }
}