package com.example.cafe;

/**
 * Class Represeting the DonutHole Object
 * @author kirtanpatel
 * @author Adityaraj Gangopadhyay
 */
public class DonutHole extends Donut{
    private static final double PRICE = 0.39;

    /**
     * Donut Hole Constructor
     * @param type Type of Donut
     * @param selectedQuantity Selected Quantity of Donut
     */
    public DonutHole(String type, Integer selectedQuantity) {
        super(type, selectedQuantity);
    }

    /**
     * Method to get Item
     * @return Price * Number of Donuts
     */
    @Override
    public double itemPrice() {
        return PRICE * super.getQuantity();
    }
}