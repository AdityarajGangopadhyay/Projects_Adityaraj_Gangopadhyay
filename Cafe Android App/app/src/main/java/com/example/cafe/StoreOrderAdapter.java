package com.example.cafe;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;



import java.util.List;

/**
 * Class Representing StoreOrderAdapter Object
 * @author Kirtan Patel
 * @author Adityaraj Gangopadhyay
 */
public class StoreOrderAdapter extends ArrayAdapter<Order> {

    private static final double TAX = 0.06625;
    private double subtotal;

    /**
     * Constructor for StoreOrderAdapter Class
     * @param context Current Context of Activity.
     * @param orders List of Orders for Activity.
     */
    public StoreOrderAdapter(Context context, List<Order> orders) {
        super(context, 0, orders);
    }

    /**
     * Gets the view of the StoreOrderAdapter.
     * @param position int of current Position.
     * @param convertView View of convertView.
     * @param parent ViewGroup representing parent.
     * @return returns View.
     */
    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        Order order = getItem(position);

        if (convertView == null) {
            convertView = LayoutInflater.from(getContext()).inflate(R.layout.store_order_item,
                    parent, false);
        }

        TextView storeOrderItemTitle = convertView.findViewById(R.id.store_order_item_title);

        TextView storeOrderItemPrice = convertView.findViewById(R.id.store_order_item_price);

        TextView orderNumber = convertView.findViewById(R.id.store_order_item_number);

        StringBuilder orderItemsDetails = new StringBuilder();

        for (MenuItem menuItem : order.getItems()) {
            orderItemsDetails.append(menuItem.toOrderString());
            String temp = String.format(" (%d) $%.2f", menuItem.getQuantity(),
                    menuItem.itemPrice());
            orderItemsDetails.append(temp);
            orderItemsDetails.append("\n");
        }
        subtotal = order.getSubtotal();

        orderNumber.setText("Order#" + Integer.toString(position + 1));
        storeOrderItemTitle.setText(orderItemsDetails.toString());
        storeOrderItemPrice.setText(String.format("$ %.2f (Subtotal: $ %.2f, Tax: $ %.2f)",
                calculateTotal(subtotal), subtotal, subtotal * TAX));

        return convertView;
    }

    /**
     * Helper Method to help calculate Total Price.
     * @param subtotal double representing SubTotal.
     * @return double representing Total Price.
     */
    public double calculateTotal(double subtotal){
        double tax = subtotal * TAX;
        return subtotal + tax;
    }
}