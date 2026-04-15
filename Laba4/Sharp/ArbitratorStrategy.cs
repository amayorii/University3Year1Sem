namespace Laba4
{
    public class ArbitratorStrategy : IStrategy
    {
        private readonly Semaphore thinkingPhilosophers = new(4, 4);

        public void TakeForks(int id, Table table)
        {
            thinkingPhilosophers.WaitOne();
            table.GetFork(id);
            table.GetFork((id + 1) % Program.PhilosophersCount);
        }

        public void PutForks(int id, Table table)
        {
            table.PutFork((id + 1) % Program.PhilosophersCount);
            table.PutFork(id);
            thinkingPhilosophers.Release();
        }
    }
}