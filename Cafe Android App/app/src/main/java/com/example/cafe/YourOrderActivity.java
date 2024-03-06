package com.example.cafe;

import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;


import android.content.DialogInterface;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.Toast;

/**
 * Class Representing Your Order Activity
 * @author Kirtan Patel
 * @author Adityaraj Gangopadhyay
 */
public class YourOrderActivity extends AppCompatActivity {

    private static final double TAX = 0.06625;


    private Order order;

    private EditText subTotalField, salesTaxField, totalField;

    private ListView orderListView;

    private Button placeOrderButton;

    /**
     * onCreate method to start the activity/view.
     * @param savedInstanceState Bundle of savedInstance.
     */
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_yourorder);

        order = OrderManager.getInstance().getOrder();

        subTotalField = findViewById(R.id.editTextTextPersonName3);
        subTotalField.setEnabled(false);
        salesTaxField = findViewById(R.id.editTextTextPersonName4);
        salesTaxField.setEnabled(false);
        totalField = findViewById(R.id.editTextTextPersonName5);
        totalField.setEnabled(false);
        orderListView = findViewById(R.id.listview1);
        placeOrderButton = findViewById(R.id.button4);
        OrderAdapter adapter = new OrderAdapter(this, order.getItems());
        orderListView.setAdapter(adapter);
        updateDetails();

        orderListView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                showRemoveItemDialog(position);
            }
        });

        placeOrderButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                showPlaceOrderDialog();
            }
        });
    }

    /**
     * Helper Method which actually places the Order.
     */
    private void placeOrder(){
        StoreOrder storeOrder = StoreOrder.getInstance();
        storeOrder.addOrder(order);
        OrderManager.getInstance().clearOrder();
        Toast.makeText(this, "Order Placed", Toast.LENGTH_SHORT).show();
        order = OrderManager.getInstance().getOrder();
        OrderAdapter adapter = new OrderAdapter(this, order.getItems());
        orderListView.setAdapter(adapter);
        updateDetails();
    }

    /**
     * Initiates the remove Item Dialog.
     * @param position int position of clicked on item.
     */
    private void showRemoveItemDialog(final int position) {
        AlertDialog.Builder builder = new AlertDialog.Builder(this);
        builder.setTitle("Remove Item");
        builder.setMessage("Do you want to remove this item from your order?");
        builder.setCancelable(false);
        builder.setPositiveButton("Remove", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                order.removeItem(position);
                updateDetails();
                ((OrderAdapter) orderListView.getAdapter()).notifyDataSetChanged();
                Toast.makeText(YourOrderActivity.this, "Item Removed",
                        Toast.LENGTH_SHORT).show();
            }
        });

        builder.setNegativeButton("Cancel", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                dialog.dismiss();
                Toast.makeText(YourOrderActivity.this, "Item Not Removed",
                        Toast.LENGTH_SHORT).show();
            }
        });

        AlertDialog alertDialog = builder.create();
        alertDialog.show();
    }

    /**
     * Initiates the Place Order Dialog.
     */
    private void showPlaceOrderDialog() {
        AlertDialog.Builder builder = new AlertDialog.Builder(this);
        builder.setTitle("Place Order");
        builder.setMessage("Do you want to place this order?");
        builder.setCancelable(false);
        builder.setPositiveButton("Yes", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                placeOrder();
            }
        });

        builder.setNegativeButton("Cancel", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                dialog.dismiss();
                Toast.makeText(YourOrderActivity.this, "Order Not Placed",
                        Toast.LENGTH_SHORT).show();
            }
        });

        AlertDialog alertDialog1 = builder.create();
        alertDialog1.show();
    }

    /**
     * Method to Update Your Order View
     */
     public void updateDetails(){
         double subTotal = order.getSubtotal();
         double salesTax = subTotal * TAX;
         double total = subTotal + salesTax;

         subTotalField.setText(String.format( "$ %.2f", subTotal));
         salesTaxField.setText(String.format("$ %.2f", salesTax));
         totalField.setText(String.format("$ %.2f", total));
     }

}