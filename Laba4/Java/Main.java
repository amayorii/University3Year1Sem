public class Main {
    public static final int PHILOSOPHERS_COUNT = 5;
    public static final Object lock = new Object();
    private static final Strategy strategy = new ArbitratorStrategy();

    public static void main(String[] args) {
        Table table = new Table();

        for (int i = 0; i < PHILOSOPHERS_COUNT; i++) {
            new Philosopher(i, table, strategy);
        }
    }
}
