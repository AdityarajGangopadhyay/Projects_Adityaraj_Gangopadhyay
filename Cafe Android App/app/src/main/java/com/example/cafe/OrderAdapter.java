package com.example.cafe;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.List;

/**
 * Class Representing OrderAdapter Object
 * @author kirtanpatel
 */
public class OrderAdapter extends ArrayAdapter<MenuItem> {

    private Order order;

    /**
     * Constructor for OrderAdapter Class
     * @param context Current Context of Activity.
     * @param items List of MenuItems for Activity.
     */
    public OrderAdapter(@NonNull Context context, List<MenuItem> items) {
        super(context, 0, items);
    }

    /**
     * Gets the view of the OrderAdapter.
     * @param position int of current Position.
     * @param convertView View of convertView.
     * @param parent ViewGroup representing parent.
     * @return returns View.
     */
    @Override
    public View getView(int position,  View convertView, ViewGroup parent) {
        MenuItem menuItem = getItem(position);

        if(convertView == null){
            convertView = LayoutInflater.from(getContext()).inflate(R.layout.order_item, parent,
                    false);
        }

        TextView itemType = convertView.findViewById(R.id.item_type);
        TextView itemQuantity = convertView.findViewById(R.id.item_quantity);
        TextView itemPrice = convertView.findViewById(R.id.item_price);

        itemType.setText(menuItem.toOrderString());
        itemQuantity.setText(String.valueOf(menuItem.getQuantity()));
        itemPrice.setText(String.format("$ %.2f", menuItem.itemPrice()));

        return convertView;
    }
}
