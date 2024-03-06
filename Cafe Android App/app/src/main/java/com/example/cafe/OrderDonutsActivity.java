package com.example.cafe;

import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;

import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.Toast;
import android.widget.Button;

import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import java.util.ArrayList;
import java.util.List;

/**
 * Class Representing Order Donuts Activity
 * @author Kirtan Patel
 * @author Adityaraj Gangopadhyay
 */
public class OrderDonutsActivity extends AppCompatActivity implements DonutAdapter.OnDonutClickListener{

    private Spinner flavorSpinner, quantitySpinner;
    private RecyclerView recyclerView;
    private Button addTOOrder;
    private DonutAdapter adapter;
    private Order order;
    private Donut donut;
    private EditText donutSubTotal;
    private int currentPosition = -1;
    private final String[] yeastDonuts = {"Jelly","Glazed","Chocolate Frosted", "Chocolate Glazed",
            "Strawberry Frosted", "Boston Cream"};
    private final String[] cakeDonuts = {"Cinnamon Sugar", "Old Fashion" , "Blueberry"};
    private final String[] donutHoles = {"ButterFingers", "Nutella Churro", "Italian Cherry"};
    private final Integer[] quantity = {1,2,3,4,5,6,7,8,9,10,11,12};

    private static final double TAX = 0.06625;

    /**
     * onCreate method to start the activity/view.
     * @param savedInstanceState Bundle of savedInstance.
     */
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_orderdonuts);

        //order = (Order) getIntent().getSerializableExtra("ORDER");

        order = OrderManager.getInstance().getOrder();
        donutSubTotal = findViewById(R.id.donutSubTotal);
        quantitySpinner = findViewById(R.id.spinner2);
        recyclerView = findViewById(R.id.recyclerView);
        addTOOrder = findViewById(R.id.add_to_order_button);
        addTOOrder.setOnClickListener(v -> onAddtoOrderClick());
        setQuantitySpinner();
        setRecyclerView();
        quantitySpinner.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            public void onItemSelected(AdapterView<?> parent, View view, int pos, long id) {
                if(currentPosition >= 0){
                    onDonutClick(currentPosition);
                }
            }
            public void onNothingSelected(AdapterView<?> parent) {}
        });
    }


    /**
     * Method to load the Quantity Spinner
     */
    protected void setQuantitySpinner(){
        ArrayAdapter<Integer> quantityAdapter = new ArrayAdapter<>(this,
                android.R.layout.simple_spinner_item, quantity);
        quantityAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        quantitySpinner.setAdapter(quantityAdapter);
    }

    /**
     * Method to load the Recycler View
     */
    protected void setRecyclerView(){
        recyclerView.setLayoutManager(new LinearLayoutManager(this));
        List<Donut> donutList = populateDonutsList();
        adapter = new DonutAdapter(this,donutList, this);
        recyclerView.setAdapter(adapter);
    }

    /**
     * Method to populate donut list
     * @return  The list of Donuts
     */
    protected List<Donut> populateDonutsList() {
        List<Donut> donutList = new ArrayList<>();

        for (String yeastDonut : yeastDonuts) {
            donutList.add(new YeastDonut(yeastDonut, 1));
        }

        for (String cakeDonut : cakeDonuts) {
            donutList.add(new CakeDonut(cakeDonut, 1));
        }
        for (String donutHole : donutHoles) {
            donutList.add(new DonutHole(donutHole, 1));
        }
        return donutList;
    }

    /**
     * Method for Donut Click in the recycler view
     * @param position Position of selected Donut
     */
    @Override
    public void onDonutClick(int position) {
        // Handle the click event here
        // For example, you can display a Toast message or start a new activity with the selected donut details
        currentPosition = position;
        Donut selectedDonut = adapter.getDonutList().get(position);
        double price = 0;
        int selectedQuantity = (int) quantitySpinner.getSelectedItem();
        //Log.d("Check", Integer.toString(selectedQuantity));
        if (selectedDonut instanceof YeastDonut) {
            price = new YeastDonut(selectedDonut.getType(),
                    selectedQuantity).itemPrice();
        } else if (selectedDonut instanceof CakeDonut) {
            price = new CakeDonut(selectedDonut.getType(),
                    selectedQuantity).itemPrice();
        } else {
            price = new DonutHole(selectedDonut.getType(),
                    selectedQuantity).itemPrice();
        }
        Toast.makeText(this, "Selected: " + selectedDonut.getType(),
                Toast.LENGTH_SHORT).show();
        donutSubTotal.setText(String.format("$%.2f", price));
    }




    /**
     * Method to Handle Add to Order Click
     */
    public void onAddtoOrderClick() {
        int position = adapter.getSelectedItemPosition();
        if (position == RecyclerView.NO_POSITION) {
            Toast.makeText(this, "Please select a donut to add to the order.",
                    Toast.LENGTH_SHORT).show();
            return;
        }
        Donut selectedDonut = adapter.getDonutList().get(position);
        int selectedQuantity = (int) quantitySpinner.getSelectedItem();

        if (selectedDonut instanceof YeastDonut) {
            donut = new YeastDonut(selectedDonut.getType(), selectedQuantity);
        } else if (selectedDonut instanceof CakeDonut) {
            donut = new CakeDonut(selectedDonut.getType(), selectedQuantity);
        } else {
            donut = new DonutHole(selectedDonut.getType(), selectedQuantity);
        }
        AlertDialog.Builder builder = new AlertDialog.Builder(this);
        builder.setTitle("Add to Order")
                .setMessage("Do you want to add " + selectedQuantity + " " + selectedDonut.getType()
                        + " donuts to the order?")
                .setPositiveButton("Add to Order", (dialog, id) -> {
                    order.addItem(donut);
                    Toast.makeText(this, selectedQuantity + " " +
                            selectedDonut.getType() + " added to the order",
                            Toast.LENGTH_SHORT).show();
                    quantitySpinner.setSelection(0);
                    //setRecyclerView();
                    //setQuantitySpinner();
                })
                .setNegativeButton("Cancel", (dialog, id) -> {
                    dialog.dismiss();
                    Toast.makeText(this, "Order not Added", Toast.LENGTH_SHORT).show();
                    //setRecyclerView();
                    //setQuantitySpinner();
                });
        AlertDialog alertDialog = builder.create();
        alertDialog.show();
    }
}
