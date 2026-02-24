package com.company;

public class MainThread extends Thread{
    private final int id;

    public MainThread(int id) {
        this.id = id;
    }

    @Override
    public void run() {
        long sum = 0;
        long count = 0;
        do {
            sum += 2;
            count++;
        } while (!Main.canBreak);
        System.out.println("id - " + id + " | sum - " + sum + " | amount of elements - " + count);
    }
}
