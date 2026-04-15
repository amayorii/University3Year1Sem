import java.util.concurrent.Semaphore;

class ArbitratorStrategy implements Strategy {
    private final Semaphore thinkingPhilosophers = new Semaphore(4, true);

    @Override
    public void takeForks(int id, Table table) {
        try {
            thinkingPhilosophers.acquire();
            table.getFork(id);
            table.getFork((id + 1) % Main.PHILOSOPHERS_COUNT);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
    }

    @Override
    public void putForks(int id, Table table) {
        table.putFork((id + 1) % Main.PHILOSOPHERS_COUNT);
        table.putFork(id);
        thinkingPhilosophers.release();
    }
}