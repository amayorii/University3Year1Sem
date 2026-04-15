class Philosopher implements Runnable {
    private final Table table;
    private final int id;
    private final Thread thread;
    private final Strategy strategy;

    public Philosopher(int id, Table table, Strategy strategy) {
        this.id = id;
        this.table = table;
        this.strategy = strategy;

        this.thread = new Thread(this);
        this.thread.start();
    }

    @Override
    public void run() {
        // ANSI Color Codes
        String cyan = "\u001B[36m";
        String yellow = "\u001B[33m";
        String reset = "\u001B[0m";

        for (int i = 0; i < 10; i++) {
            synchronized (Main.lock) {
                System.out.println(cyan + "Philosopher" + id + " is thinking " + (i + 1) + " times" + reset);
            }

            strategy.takeForks(id, table);

            synchronized (Main.lock) {
                System.out.println(yellow + "Philosopher" + id + " is eating " + (i + 1) + " times" + reset);
            }

            strategy.putForks(id, table);
        }
    }
}