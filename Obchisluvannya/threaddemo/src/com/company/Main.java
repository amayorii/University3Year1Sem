package com.company;

import java.util.Scanner;

public class Main {

    public static volatile boolean canBreak = false;
    public static void main() {
        int threadsCount = 3;

        Scanner scanner = new Scanner(System.in);

        System.out.print("Enter amount of threads: ");
        if (scanner.hasNextInt()) {
            threadsCount = scanner.nextInt();
        }
        
        for (int i = 0; i < threadsCount; i++) {
            new MainThread(i).start();
        }

        BreakThread breakThread = new BreakThread();
        new Thread(breakThread).start();
    }
}
