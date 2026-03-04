package com.company;

import java.util.*;
import java.util.stream.Collectors;

public class ThreadStopper {
    private final Thread monitorThread;
    private final Map<Integer, Integer> timers = new HashMap<>();
    private final List<ThreadCalculator> threads = new ArrayList<>();

    public ThreadStopper() {
        this.monitorThread = new Thread(this::stopperLogic);
    }

    private void stopperLogic() {
        // Сортуємо таймери за значенням (часом очікування)
        List<Map.Entry<Integer, Integer>> sortedTimers = timers.entrySet()
                .stream()
                .sorted(Map.Entry.comparingByValue())
                .collect(Collectors.toList());

        int elapsedTime = 0;
        for (Map.Entry<Integer, Integer> entry : sortedTimers) {
            try {
                int waitTime = entry.getValue() - elapsedTime;
                if (waitTime > 0) {
                    Thread.sleep(waitTime);
                }
                elapsedTime = entry.getValue();

                // Зупиняємо відповідний потік (id - 1, бо в списку індексація з 0)
                threads.get(entry.getKey() - 1).stop();
                
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
        }
    }

    public void addThread(ThreadCalculator thread) {
        threads.add(thread);
        int randomTime = (int) (Math.random() * (10000 - 2000) + 2000); // 2000 - 10000 ms
        timers.put(thread.getThreadId(), randomTime);
        System.out.println("Thread " + thread.getThreadId() + " will stop in: " + randomTime + " ms");
    }

    public void start() {
        monitorThread.start();
    }
}