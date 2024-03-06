package com.example.cafe;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.ImageButton;


import java.io.Serializable;

/**
 * Main Class for The Whole Project and controls the Main Activity of Main View.
 * @author Kirtan Patel
 * @author Adityaraj Gangopadhyay
 */
public class MainActivity extends AppCompatActivity {

    private ImageButton orderDonuts, orderCoffee, yourOrder, storeOrder;

    private Order order = new Order();

    public void setOrder(Order order){
        this.order = order;
    }

    private static final int ORDER_DONUTS_REQUEST = 1;
    private static final int ORDER_COFFEE_REQUEST = 2;
    private static final int YOUR_ORDER_REQUEST = 3;
    private static final int STORE_ORDER_REQUEST = 4;

    /**
     * Method to Handle creation of Main View and Activity.
     * @param savedInstanceState Bundle of savedInstance.
     */
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
    }

    /**
     * Method to launch OrderDonuts View
     * @param view Current View of MainActivity
     */
    public void onOrderDonutsClick(View view){
        Intent intent = new Intent(MainActivity.this, OrderDonutsActivity.class);
        //intent.putExtra("ORDER", order);
        startActivity(intent);
    }

    /**
     * Method to launch OrderCoffee View
     * @param view Current View of MainActivity
     */
    public void onOrderCoffeeClick(View view){
        Intent intent = new Intent(MainActivity.this, OrderCoffeeActivity.class);
        intent.putExtra("ORDER", order);
        //startActivityForResult(intent, ORDER_COFFEE_REQUEST);
        startActivity(intent);

    }

    /**
     * Method to launch YourOrder view
     * @param view Current View of MainActivity
     */
    public void onYourOrderClick(View view){
        Intent intent = new Intent(MainActivity.this, YourOrderActivity.class);
        intent.putExtra("ORDER", order);
        //startActivityForResult(intent, YOUR_ORDER_REQUEST);
        startActivity(intent);
    }

    /**
     * Method to launch StoreOrders View
     * @param view Current View of MainActivity
     */
    public void onStoreOrderClick(View view){
        Intent intent = new Intent(MainActivity.this, StoreOrderActivity.class);
        intent.putExtra("ORDER", order);
        //startActivityForResult(intent, STORE_ORDER_REQUEST);
        startActivity(intent);
    }


}