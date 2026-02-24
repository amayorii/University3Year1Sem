package com.company;

public class BreakThread implements Runnable {
    @Override
    public void run() {
        try {
            Thread.sleep(30 * 1000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        Main.canBreak = true;
    }
}
