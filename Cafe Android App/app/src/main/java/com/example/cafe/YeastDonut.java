package com.example.cafe;

/**
 * Class representing Yeast Donut Types
 * @author kirtanpatel
 * @author Adityaraj Gangopadhyay
 */
public class YeastDonut extends Donut {
    private static final double PRICE = 1.59;

    /**
     * Yeast Donut Controller
     * @param type             String Type
     * @param selectedQuantity Quantity Selected
     */
    public YeastDonut(String type, Integer selectedQuantity) {
        super(type, selectedQuantity);

    }

    /**
     * Item Price Method
     * @return Price * Quantity
     */
    @Override
    public double itemPrice() {
        return PRICE * super.getQuantity();
    }
}
