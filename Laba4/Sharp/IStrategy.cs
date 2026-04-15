namespace Laba4
{
    public interface IStrategy
    {
        void TakeForks(int philosopherId, Table table);
        void PutForks(int philosopherId, Table table);
    }
}