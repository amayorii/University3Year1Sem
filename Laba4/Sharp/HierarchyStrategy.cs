namespace Laba4
{
    public class HierarchyStrategy : IStrategy
    {
        public void TakeForks(int id, Table table)
        {
            if (id == Program.PhilosophersCount - 1)
            {
                table.GetFork((id + 1) % Program.PhilosophersCount);
                table.GetFork(id);
            }
            else
            {
                table.GetFork(id);
                table.GetFork((id + 1) % Program.PhilosophersCount);
            }
        }

        public void PutForks(int id, Table table)
        {
            if (id == Program.PhilosophersCount - 1)
            {
                table.PutFork(id);
                table.PutFork((id + 1) % Program.PhilosophersCount);
            }
            else
            {
                table.PutFork((id + 1) % Program.PhilosophersCount);
                table.PutFork(id);
            }
        }
    }
}