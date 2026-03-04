using System.Threading;
using System;

namespace threaddemo
{
    public class Program
    {
        static void Main()
        {
            System.Console.Write("Enter amount of threads: ");
            int amount = Convert.ToInt32(Console.ReadLine());

            ThreadStopper stopper = new ThreadStopper();

            for (int i = 0; i < amount; i++)
            {
                var thread = new ThreadCalculator(i + 1);
                stopper.AddThread(thread);
                thread.Start();
            }

            stopper.Start();
        }
    }
}