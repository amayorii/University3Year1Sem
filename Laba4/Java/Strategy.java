interface Strategy {
    void takeForks(int philosopherId, Table table);
    void putForks(int philosopherId, Table table);
}