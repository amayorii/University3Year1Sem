namespace Laba4
{
    public class Table
    {
        private readonly Semaphore[] forks = new Semaphore[Program.PhilosophersCount];

        public Table()
        {
            for (int i = 0; i < forks.Length; i++)
            {
                forks[i] = new Semaphore(1, 1);
            }
        }

        public void GetFork(int id)
        {
            forks[id].WaitOne();
        }

        public void PutFork(int id)
        {
            forks[id].Release();
        }
    }
}