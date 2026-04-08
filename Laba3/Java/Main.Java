import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.Semaphore;

public class Main {
    private final int consAmount = 3;
    private final int prodsAmount = 2;
    private final static int storageSize = 3;
    private final int itemsNeeded = 20;
    
    private int itemsNow = 0;
    private final List<String> storage = new ArrayList<>();

    private final Semaphore access = new Semaphore(1);
    private final Semaphore workSpace = new Semaphore(storageSize);
    private final Semaphore availableProducts = new Semaphore(0);

    public static void main(String[] args) {
        Main program = new Main();
        program.start();
    }

    private void start() {
        int tempChunkProd = itemsNeeded / prodsAmount;
        int tempChunkCons = itemsNeeded / consAmount;
        int remainderProds = itemsNeeded % prodsAmount;
        int remainderCons = itemsNeeded % consAmount;

        for (int i = 0; i < consAmount; i++) {
            int chunk = (i == consAmount - 1) ? remainderCons + tempChunkCons : tempChunkCons;
            
            int index = i; 
            int finalChunk = chunk;

            Thread threadConsumer = new Thread(() -> consumer(index, finalChunk));
            threadConsumer.start();
        }

        for(int i = 0; i < prodsAmount; i++){
            int chunk = (i == prodsAmount - 1) ? remainderProds + tempChunkProd : tempChunkProd;

            int index = i; 
            int finalChunk = chunk;

            Thread threadProducer = new Thread(() -> producer(index, finalChunk));
            threadProducer.start();
        }
    }

    private void producer(int index, int amount) {
        for (int i = 0; i < amount; i++) {
            try {
                workSpace.acquire();
                access.acquire();

                storage.add("item " + itemsNow);
                System.out.println("Producer " + index + " added item " + itemsNow);
                itemsNow++;

                access.release();
                availableProducts.release();
                
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt(); 
            }
        }
    }

    private void consumer(int index, int amount) {
        for (int i = 0; i < amount; i++) {
            try {
                availableProducts.acquire();
                Thread.sleep(1000);
                access.acquire();

                String item = storage.remove(0);

                System.out.println("Consumer " + index + " took " + item);

                workSpace.release();
                access.release();
                
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
        }
    }
}