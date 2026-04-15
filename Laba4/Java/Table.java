import java.util.concurrent.Semaphore;

public class Table {
    private final Semaphore[] forks = new Semaphore[Main.PHILOSOPHERS_COUNT];

    public Table() {
        for (int i = 0; i < forks.length; i++) {
            forks[i] = new Semaphore(1, true); 
        }
    }

    public void getFork(int id) {
        try {
            forks[id].acquire();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
    }

    public void putFork(int id) {
        forks[id].release();
    }
}