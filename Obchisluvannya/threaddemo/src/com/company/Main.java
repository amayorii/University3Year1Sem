package com.company;

import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        
        System.out.print("Enter amount of threads: ");
        int amount = scanner.nextInt();

        ThreadStopper stopper = new ThreadStopper();

        for (int i = 0; i < amount; i++) {
            ThreadCalculator calculator = new ThreadCalculator(i + 1);
            stopper.addThread(calculator);
            calculator.start();
        }

        stopper.start();
        
        // scanner.close(); // Рекомендується закривати потік введення
    }
}