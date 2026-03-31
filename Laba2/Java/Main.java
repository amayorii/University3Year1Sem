import java.util.Random;

public class Main {
    private static final int LENGTH = 1_000_000;
    private static final int THREAD_NUM = 8;
    
    private final int[] arr = new int[LENGTH];
    private int finishedThreadCount = 0;
    private long minValue = Long.MAX_VALUE;
    private int minIndex = -1;

    private final Object lockerForMin = new Object();
    private final Object lockerForLivingThread = new Object();

    public static void main(String[] args) throws InterruptedException {
        Main program = new Main();
        program.initArr();

        long start = System.currentTimeMillis();
        Result seqResult = program.partMin(0, LENGTH);
        long end = System.currentTimeMillis();
        
        System.out.println("Sequential min: " + seqResult.value() + " | Index: " + seqResult.index());
        System.out.println("Elapsed time: " + (end - start) + " ms");

        start = System.currentTimeMillis();
        long parMin = program.parallelMin();
        end = System.currentTimeMillis();

        System.out.println("Parallel min:   " + parMin + " | Index: " + program.minIndex);
        System.out.println("Elapsed time: " + (end - start) + " ms");
    }

    private void initArr() {
        Random rnd = new Random();
        for (int i = 0; i < LENGTH; i++) {
            arr[i] = rnd.nextInt(LENGTH);
        }
        arr[567738] = -58890;
    }

    private long parallelMin() throws InterruptedException {
        int chunkSize = LENGTH / THREAD_NUM;
        Thread[] threads = new Thread[THREAD_NUM];

        for (int i = 0; i < THREAD_NUM; i++) {
            int start = i * chunkSize;
            int end = (i == THREAD_NUM - 1) ? LENGTH : start + chunkSize;

            threads[i] = new Thread(() -> parallelWorker(start, end));
            threads[i].start();
        }

        synchronized (lockerForLivingThread) {
            while (finishedThreadCount < THREAD_NUM) {
                lockerForLivingThread.wait();
            }
        }
        return minValue;
    }

    private void parallelWorker(int start, int end) {
        Result result = partMin(start, end);

        synchronized (lockerForMin) {
            reassignMin(result.value(), result.index());
        }

        incThreadCount();
    }

    private void incThreadCount() {
        synchronized (lockerForLivingThread) {
            finishedThreadCount++;
            lockerForLivingThread.notifyAll();
        }
    }

    public void reassignMin(long localMin, int index) {
        if (localMin < minValue) {
            this.minValue = localMin;
            this.minIndex = index;
        }
    }

    public Result partMin(int startIndex, int finishIndex) {
        long localMin = Long.MAX_VALUE;
        int localIndex = -1;
        for (int i = startIndex; i < finishIndex; i++) {
            if (arr[i] < localMin) {
                localMin = arr[i];
                localIndex = i;
            }
        }
        return new Result(localMin, localIndex);
    }

    record Result(long value, int index) {}
}