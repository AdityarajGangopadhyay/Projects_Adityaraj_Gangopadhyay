package com.example.cafe;

/**
 * Class Representing Menu Items.
 * @author Adityaraj Gangopadhay
 * @author Kirtan Patel
 */
public abstract class MenuItem {
    private int quantity;

    /**
     * Constructor for MenuItem Object.
     * @param selectedQuantity User Selected Quantity.
     */
    public MenuItem(int selectedQuantity){
        this.quantity = selectedQuantity;
    }

    /**
     * Getter method for quantity.
     * @return int quantity of MenuItem
     */
    public int getQuantity() {
        return this.quantity;
    }

    /**
     * Setter method for quantity.
     * @param quantity new quantity to be set to.
     */
    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    /**
     * Abstract method to get MenuItem object price.
     * @return double representing item price.
     */
    public abstract double itemPrice();

    /**
     * Abstract method to print for order representation.
     * @return String for order.
     */
    public abstract String toOrderString();

}