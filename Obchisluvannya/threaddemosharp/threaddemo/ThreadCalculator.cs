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

    private volatile bool run = true;

    public ThreadCalculator(int id)
    {
        thread = new Thread(Calculator);
        ThreadId = id;
    }

    public void Stop()
    {
        run = false;
    }

    private void Calculator()
    {
        double sum = 0;
        double count = 0;
        do
        {
            count++;
            sum += 3;
        } while (run);
        Console.WriteLine($"ThreadId: {ThreadId} | Sum: {sum} | Amount of elements: {count}");
    }

    public void Start()
    {
        thread.Start();
    }
}