package com.example.cafe;

/**
 * Class representing Cake Donut Class
 * @author  Kirtan Patel
 * @author Adityaraj Gangopadhyay
 */
public class CakeDonut extends Donut{
    private static double PRICE = 1.79;

    /**
     * Cake Donut Constructor
     * @param type Donut Type
     * @param selectedQuantity Selected Quantity
     */
    public CakeDonut(String type, Integer selectedQuantity) {
        super(type,selectedQuantity);
    }

    /**
     * Item Price
     * @return Price Multiplied by Quantity
     */
    @Override
    public double itemPrice() {
        return PRICE * super.getQuantity();
    }
}