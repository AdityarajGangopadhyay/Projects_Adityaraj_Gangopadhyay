package com.example.cafe;

import java.util.List;

/**
 * Class representing Coffee object.
 * @author Adityaraj Gangopadhyay
 */
public class Coffee extends MenuItem{
    private String cupSize;
    private List<String> addIns;
    private static double basePrice = 1.89;
    private static double sizePriceJump = 0.40;
    private static double addInsPriceJump = 0.30;

    /**
     * Constructor for coffee class.
     * @param cupSize String representing cupSize.
     * @param addIns ArrayList of add-ins.
     */
    public Coffee(String cupSize, List<String> addIns, int selectedQuantity){
        super(selectedQuantity);
        this.cupSize = cupSize;
        this.addIns = addIns;
    }

    /**
     * Returns itemPrice of current coffee object.
     * @return double itemprice.
     */
    @Override
    public double itemPrice() {
        int intCupSize = 0;
        if(this.cupSize.equals("Tall")){
            intCupSize = 1;
        } else if (this.cupSize.equals("Grande")) {
            intCupSize = 2;
        } else if (this.cupSize.equals("Venti")) {
            intCupSize = 3;
        }
        return (basePrice + (intCupSize * sizePriceJump) + (addIns.size() * addInsPriceJump))
                * super.getQuantity();
    }

    /**
     * Returns string representation of coffee object for order representation.
     * @return String representation.
     */
    @Override
    public String toOrderString() {
        return String.format("Coffee %s " + addIns,  cupSize);
    }
}
