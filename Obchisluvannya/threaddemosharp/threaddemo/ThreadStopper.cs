using threaddemo;

public class ThreadStopper
{
    private readonly Thread thread;

    public ThreadStopper(int seconds)
    {
        thread = new Thread(new ParameterizedThreadStart(method => Stopper(1000 * seconds)));
    }

    private static void Stopper(int milliseconds)
    {
        Thread.Sleep(milliseconds);
        Program.CanStop = true;
    }

    public void Start()
    {
        thread.Start();
    }
}