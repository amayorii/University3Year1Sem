using threaddemo;

public class ThreadStopper
{
    private readonly Thread thread;

    private static Dictionary<int, int> timers = [];
    private static List<ThreadCalculator> threads = [];

    public ThreadStopper()
    {
        thread = new Thread(new ParameterizedThreadStart(method => Stopper()));
    }

    private static void Stopper()
    {
        var timersSorted = timers.OrderBy(x => x.Value).ToList();

        int time = 0;
        foreach (var timer in timersSorted)
        {
            Thread.Sleep(timer.Value - time);
            time = timer.Value;

            threads[timer.Key - 1].Stop();
        }
    }
    public void AddThread(ThreadCalculator thread)
    {
        threads.Add(thread);
        var random = new Random().Next(2000, 10000);
        timers[thread.ThreadId] = random;
        System.Console.WriteLine(random);
    }

    public void Start()
    {
        thread.Start();
    }
}