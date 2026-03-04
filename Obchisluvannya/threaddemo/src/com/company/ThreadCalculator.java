package com.company;

public class ThreadCalculator implements Runnable {
    private final Thread thread;
    private int id;
    private volatile boolean running = true;

    public ThreadCalculator(int id) {
        this.id = id;
        this.thread = new Thread(this);
    }

    public int getThreadId() {
        return id;
    }

    public void stop() {
        running = false;
    }

    public void start() {
        thread.start();
    }

    @Override
    public void run() {
        double sum = 0;
        double count = 0;
        
        while (running) {
            count++;
            sum += 3;
        }
        
        System.out.printf("ThreadId: %d | Sum: %.0f | Amount of elements: %.0f%n", 
                id, sum, count);
    }
}