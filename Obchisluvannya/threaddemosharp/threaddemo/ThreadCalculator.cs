using threaddemo;

public class ThreadCalculator
{
    private readonly Thread thread;
    private int id;
    public int ThreadId
    {
        get { return id; }
        set { id = value; }
    }

    public ThreadCalculator()
    {
        thread = new Thread(Calculator);
        ThreadId = thread.ManagedThreadId;
    }

    private void Calculator()
    {
        double sum = 0;
        double count = 0;
        do
        {
            count++;
            sum += 3;
        } while (!Program.CanStop);
        Console.WriteLine($"ThreadId: {ThreadId} | Sum: {sum} | Amount of elements: {count}");
    }

    public void Start()
    {
        thread.Start();
    }
}