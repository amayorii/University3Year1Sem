class HierarchyStrategy implements Strategy {
    @Override
    public void takeForks(int id, Table table) {
        if (id == Main.PHILOSOPHERS_COUNT - 1) {
            table.getFork((id + 1) % Main.PHILOSOPHERS_COUNT);
            table.getFork(id);
        } else {
            table.getFork(id);
            table.getFork((id + 1) % Main.PHILOSOPHERS_COUNT);
        }
    }

    @Override
    public void putForks(int id, Table table) {
        if (id == Main.PHILOSOPHERS_COUNT - 1) {
            table.putFork(id);
            table.putFork((id + 1) % Main.PHILOSOPHERS_COUNT);
        } else {
            table.putFork((id + 1) % Main.PHILOSOPHERS_COUNT);
            table.putFork(id);
        }
    }
}