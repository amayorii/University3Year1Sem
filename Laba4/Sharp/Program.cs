namespace Laba4;

class Program
{
    public const int PhilosophersCount = 5;
    public static object lock_ = new();
    private static readonly IStrategy strategy = new ArbitratorStrategy();
    static void Main()
    {
        Table table = new();

        for (int i = 0; i < PhilosophersCount; i++)
        {
            _ = new Philosopher(i, table, strategy);
        }
    }
}
