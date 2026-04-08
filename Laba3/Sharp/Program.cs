namespace Laba3
{
    class Program
    {
        private readonly int consAmount = 3;
        private readonly int prodAmount = 2;
        private readonly static int storageSize = 3;
        private readonly int itemsNeeded = 20;
        private int itemsNow = 0;
        private readonly List<string> storage = [];

        private readonly Semaphore access = new(1, 1);
        private readonly Semaphore workSpace = new(storageSize, storageSize);
        private readonly Semaphore availableProducts = new(0, storageSize);

        static void Main()
        {
            Program program = new();
            program.Start();
        }

        private void Start()
        {
            int tempChunkProd = itemsNeeded / prodAmount;
            int tempChunkCon = itemsNeeded / consAmount;
            int remainderProd = itemsNeeded % prodAmount;
            int remainderCon = itemsNeeded % consAmount;

            for (int i = 0; i < prodAmount; i++)
            {
                int chunk = (i == prodAmount - 1) ? remainderProd + tempChunkProd : tempChunkProd;
                int index = i;

                Thread threadProducer = new(() => Producer(index, chunk));

                threadProducer.Start();
            }

            for (int i = 0; i < consAmount; i++)
            {
                int chunk = (i == consAmount - 1) ? remainderCon + tempChunkCon : tempChunkCon;
                int index = i;

                Thread threadConsumer = new(() => Consumer(index, chunk));

                threadConsumer.Start();
            }
        }

        private void Producer(int index, int amount)
        {
            for (int i = 0; i < amount; i++)
            {
                workSpace.WaitOne();
                access.WaitOne();

                storage.Add("item " + itemsNow);
                Console.WriteLine($"Producer {index} added item " + itemsNow);
                itemsNow++;

                access.Release();
                availableProducts.Release();
            }
        }

        private void Consumer(int index, int amount)
        {
            for (int i = 0; i < amount; i++)
            {
                availableProducts.WaitOne();
                Thread.Sleep(1000);
                access.WaitOne();

                string item = storage[0];
                storage.RemoveAt(0);

                Console.WriteLine($"Consumer {index} took " + item);

                workSpace.Release();
                access.Release();
            }
        }
    }
}
