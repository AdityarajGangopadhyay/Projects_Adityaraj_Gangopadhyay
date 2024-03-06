package com.example.cafe;

import androidx.annotation.XmlRes;
import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;

import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;

import java.util.ArrayList;
import java.util.List;

/**
 * Class Representing Order Coffee Activity
 * @author Adityaraj Gangopadhyay
 */
public class OrderCoffeeActivity extends AppCompatActivity {

    private CheckBox sweetCream, mocha, irishCream, frenchVanilla, caramel;

    private Spinner coffeeQuantity, coffeeSize;

    private TextView coffeeSubTotal;

    private Button coffeeAdd;

    private Coffee coffee;

    private static String[] coffeeSizes = {"Short", "Tall", "Grande", "Venti"};
    private static Integer[] coffeeQuantityArray = {1, 2, 3, 4, 5};

    private Order order;

    /**
     * Setter method for Order for activity.
     * @param order Order object for application.
     */
    public void setOrder(Order order){
        this.order = order;
    }

    /**
     * onCreate method to start the activity/view.
     * @param savedInstanceState Bundle of savedInstance.
     */
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_ordercoffee);
        getIntent().setClass(OrderCoffeeActivity.this, OrderCoffeeActivity.class);
        //order = (Order) getIntent().getSerializableExtra("ORDER");
        order = OrderManager.getInstance().getOrder();
        coffeeSubTotal = findViewById(R.id.coffeeSubTotal);
        coffeeSubTotal.setText(R.string.zeroDollars);
        sweetCream = findViewById(R.id.sweetCream);
        mocha = findViewById(R.id.mocha);
        irishCream = findViewById(R.id.irishCream);
        frenchVanilla = findViewById(R.id.frenchVanilla);
        caramel = findViewById(R.id.caramel);
        coffeeSize = findViewById(R.id.coffeeSize);
        coffeeQuantity = findViewById(R.id.coffeeQuantity);
        ArrayAdapter<String> coffeeSizesAdapter = new ArrayAdapter<>(this,
                android.R.layout.simple_spinner_dropdown_item, coffeeSizes);
        coffeeSizesAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        coffeeSize.setAdapter(coffeeSizesAdapter);
        coffeeSize.setSelection(0);
        ArrayAdapter<Integer> coffeeQuantityAdapter = new ArrayAdapter<>(this,
                android.R.layout.simple_spinner_dropdown_item, coffeeQuantityArray);
        coffeeQuantityAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        coffeeQuantity.setAdapter(coffeeQuantityAdapter);
        coffeeQuantity.setSelection(0);
        updateCoffee(findViewById(android.R.id.content).getRootView());
        coffeeSize.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            public void onItemSelected(AdapterView<?> parent, View view, int pos, long id) {
                updateCoffee(findViewById(android.R.id.content).getRootView());
            }
            public void onNothingSelected(AdapterView<?> parent) {}
        });
        coffeeQuantity.setOnItemSelectedListener(coffeeSize.getOnItemSelectedListener());
    }


    /**
     * Method updates the running subtotal for coffee.
     * @param view Current View of OrderCoffeeActivity
     */
    public void updateCoffee(View view){
        List<String> selectedAddIns = new ArrayList<String>();
        if(sweetCream.isChecked()){selectedAddIns.add("Sweet Cream");}
        if(mocha.isChecked()){selectedAddIns.add("Mocha");}
        if(frenchVanilla.isChecked()){selectedAddIns.add("French Vanilla");}
        if(caramel.isChecked()){selectedAddIns.add("Caramel");}
        if(irishCream.isChecked()){selectedAddIns.add("Irish Cream");}
        coffee = new Coffee(coffeeSize.getSelectedItem().toString(), selectedAddIns,
                Integer.parseInt(coffeeQuantity.getSelectedItem().toString()));
        coffeeSubTotal.setText(String.format("$%.2f", coffee.itemPrice()));
    }

    /**
     * Adds coffee to order depending on alert dialog decision.
     * @param view Current View of OrderCoffeeActivity
     */
    public void coffeeAddToOrder(View view){
        AlertDialog.Builder builder1 = new AlertDialog.Builder(OrderCoffeeActivity.this);
        builder1.setMessage("Are You Sure You Want To Add This To Order?");
        builder1.setCancelable(false);
        builder1.setPositiveButton(
                "Yes",
                new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int id) {
                        order.addItem(coffee);
                        Toast.makeText(OrderCoffeeActivity.this, "Order Added",
                                Toast.LENGTH_SHORT).show();
                        coffeeSize.setSelection(0);
                        coffeeQuantity.setSelection(0);
                        sweetCream.setChecked(false);
                        mocha.setChecked(false);
                        frenchVanilla.setChecked(false);
                        caramel.setChecked(false);
                        irishCream.setChecked(false);
                        updateCoffee(findViewById(android.R.id.content).getRootView());
                        dialog.cancel();
                    }
                });
        builder1.setNegativeButton(
                "No",
                new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int id) {
                        Toast.makeText(OrderCoffeeActivity.this, "Order Not Added",
                                Toast.LENGTH_SHORT).show();
                        dialog.cancel();
                    }
                });
        AlertDialog alert11 = builder1.create();
        alert11.show();
    }
}
