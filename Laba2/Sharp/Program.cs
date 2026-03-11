using System;
using System.Diagnostics;
using System.Threading;

namespace Laba2
{
    class Program
    {
        private static readonly int length = 10000000;
        private readonly int[] arr = new int[length];
        private static readonly int threadNum = 8;
        private int finishedThreadCount = 0;
        private long min = long.MaxValue;
        private long index = -1;
        private readonly Thread[] thread = new Thread[threadNum];
        private readonly Lock lockerForMin = new();
        private readonly object lockerForLivingThread = new();

        static void Main(string[] args)
        {
            Program main = new Program();
            main.InitArr();
            Stopwatch sw = new();

            sw.Start();
            var result = main.PartMin(0, length);
            Console.WriteLine("Sequential min: " + result.Item1 + " | " + "Index: " + result.Item2);
            sw.Stop();

            System.Console.WriteLine($"Elapsed time: {sw.ElapsedMilliseconds} ms");

            sw.Restart();
            Console.WriteLine("Parallel min:   " + main.ParallelMin() + " | " + "Index: " + main.index);
            sw.Stop();

            System.Console.WriteLine($"Elapsed time: {sw.ElapsedMilliseconds} ms");
        }

        private void InitArr()
        {
            Random rnd = new();
            for (int i = 0; i < length; i++)
            {
                arr[i] = rnd.Next(0, length);
            }

            arr[567738] = -500;
        }

        private long ParallelMin()
        {
            int chunkSize = length / threadNum;

            for (int i = 0; i < threadNum; i++)
            {
                int start = i * chunkSize;
                int end = (i == threadNum - 1) ? length : start + chunkSize;

                thread[i] = new Thread(ParallelSumThread!);
                thread[i].Start(new Bound(start, end));
            }

            lock (lockerForLivingThread)
            {
                while (finishedThreadCount < threadNum)
                {
                    Monitor.Wait(lockerForLivingThread);
                }
            }
            return min;
        }

        private void ParallelSumThread(object param)
        {
            if (param is Bound paramBound)
            {
                (long, int) result = PartMin(paramBound.StartIndex, paramBound.FinishIndex);

                lock (lockerForMin)
                {
                    ReassignMin(result.Item1, result.Item2);
                }

                IncThreadCount();
            }
        }

        private void IncThreadCount()
        {
            lock (lockerForLivingThread)
            {
                finishedThreadCount++;
                Monitor.Pulse(lockerForLivingThread);
            }
        }

        public void ReassignMin(long localMin, int index)
        {
            if (localMin < min)
            {
                min = localMin;
                this.index = index;
            }
        }

        public (long, int) PartMin(int startIndex, int finishIndex)
        {
            long localMin = long.MaxValue;
            int localIndex = -1;
            for (int i = startIndex; i < finishIndex; i++)
            {
                if (arr[i] < localMin)
                {
                    localMin = arr[i];
                    localIndex = i;
                }
            }
            return (localMin, localIndex);
        }
    }
    class Bound
    {
        public Bound(int startIndex, int finishIndex)
        {
            StartIndex = startIndex;
            FinishIndex = finishIndex;
        }

        public int StartIndex { get; set; }
        public int FinishIndex { get; set; }
    }
}
