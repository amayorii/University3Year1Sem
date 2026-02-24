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
            System.Console.Write("Enter sleep seconds: ");
            int seconds = Convert.ToInt32(Console.ReadLine());

            for (int i = 0; i < amount; i++)
            {
                new ThreadCalculator().Start();
            }

            new ThreadStopper(seconds).Start();
        }

        private static bool canStop = false;

        public static bool CanStop { get => canStop; set => canStop = value; }
    }
}