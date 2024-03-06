package com.example.cafe;

/**
 * Instance Class for Order to share between Activities.
 * @author Kirtan Patel
 */
public class OrderManager {
    private static OrderManager instance;
    private Order order;

    /**
     * Constructor for OrderManager.
     */
    private OrderManager() {
        order = new Order();
    }

    /**
     * getInstance method for OrderManager
     * @return returns current instance of OrderManager or creates a new one if none exists.
     */
    public static OrderManager getInstance() {
        if (instance == null) {
            instance = new OrderManager();
        }
        return instance;
    }

    /**
     * Clears the instance.
     */
    public void clearOrder(){
        order = new Order();
    }

    /**
     * Getter method for the current instance.
     * @return Order of current instance.
     */
    public Order getOrder() {
        return order;
    }
}
