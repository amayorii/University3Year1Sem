using System.Threading;
using System;

namespace threaddemo
{
    class Program
    {
        static void Main(string[] args)
        {
            (new Program()).Start();
        }

        void Start()
        {
            (new Thread(Calcuator)).Start();
            (new Thread(Calcuator)).Start();
            (new Thread(Calcuator)).Start();

            Thread thread1 = new Thread(Calcuator);
            thread1.Start();

            (new Thread(Stoper)).Start();
        }

        void Calcuator()
        {
            long sum = 0;
            do
            {
                sum++;
            } while (!canStop);
            Console.WriteLine(sum);
        }

        private bool canStop = false;

        public bool CanStop { get => canStop; }

        public void Stoper()
        {
            Thread.Sleep(30 * 1000);
            canStop = true;
        }
    }
}
