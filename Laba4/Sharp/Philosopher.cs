namespace Laba4
{
    public class Philosopher
    {
        private readonly Table table;
        private readonly int id;
        private readonly Thread thread;
        private readonly IStrategy strategy;

        public Philosopher(int id, Table table, IStrategy strategy)
        {

            this.id = id;
            this.table = table;
            this.strategy = strategy;

            thread = new Thread(Start);
            thread.Start();
        }

        public void Start()
        {
            for (int i = 0; i < 10; i++)
            {
                lock (Program.lock_)
                {
                    Console.ForegroundColor = ConsoleColor.DarkCyan;
                    System.Console.WriteLine("Philosopher" + id + " is thinking " + (i + 1) + " times");
                    // Thread.Sleep(Random.Shared.Next(10, 100));
                    Console.ResetColor();
                }

                strategy.TakeForks(id, table);

                lock (Program.lock_)
                {
                    Console.ForegroundColor = ConsoleColor.DarkYellow;
                    System.Console.WriteLine("Philosopher" + id + " is eating " + (i + 1) + " times");
                    // Thread.Sleep(Random.Shared.Next(10, 100));
                    Console.ResetColor();
                }

                strategy.PutForks(id, table);
            }
        }

    }
}