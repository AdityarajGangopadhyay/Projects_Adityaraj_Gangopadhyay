package com.example.cafe;

/**
 * Class Representing Donut Object
 * @author kirtanpatel
 * @author Adityaraj Gangopadhyay
 */
public abstract class Donut extends MenuItem{
    private String type;

    /**
     * Donut Constructor
     * @param type Type of Donut
     * @param selectedQuantity Selected Donut Quantity
     */
    public Donut(String type, int selectedQuantity) {
        super(selectedQuantity);
        this.type = type;
    }

    /**
     * Setter Method for Type
     * @param type Donut Type
     */
    public void setType(String type) {
        this.type = type;
    }

    /**
     * Getter Method for  Type
     * @return Type of Donut
     */
    public String getType() {
        return type;
    }

    /**
     * Getter Method For Quantity
     * @return Donut Quantity
     */
    public int getQuantity() {
        return super.getQuantity();
    }

    /**
     * To string Method for adding object to orderlist
     * @return The order String
     */
    @Override
    public String toOrderString(){
        return type;
    }

    /**
     * To string method
     * @return Type of item
     */
    @Override
    public String toString(){
        return type;
    }
}