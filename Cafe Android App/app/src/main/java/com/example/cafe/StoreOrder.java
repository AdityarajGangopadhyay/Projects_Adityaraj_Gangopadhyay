package com.example.cafe;

import java.util.ArrayList;
import java.util.List;

/**
 * Instance Class for List of Orders to share between Activities.
 * @author Kirtan Patel
 */
public class StoreOrder {
    private static StoreOrder instance;
    private List<Order> orders;

    /**
     * Constructor for StoreOrder.
     */
    private StoreOrder() {
        orders = new ArrayList<>();
    }

    /**
     * getInstance method for StoreOrder
     * @return returns current instance of StoreOrder or creates a new one if none exists.
     */
    public static StoreOrder getInstance() {
        if (instance == null) {
            instance = new StoreOrder();
        }
        return instance;
    }

    /**
     * Adds order to current Instance.
     * @param order Order to be added.
     */
    public void addOrder(Order order) {
        orders.add(order);
    }

    /**
     * Getter method for the current instance.
     * @return List of Orders of current instance.
     */
    public List<Order> getOrders() {
        return orders;
    }

    /**
     * Removes order from current instance.
     * @param index int Index of Order to be removed.
     */
    public void removeOrder(int index) {
        orders.remove(index);
    }

}
