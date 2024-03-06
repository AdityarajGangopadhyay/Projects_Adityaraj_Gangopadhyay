package com.example.cafe;

import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;

import android.content.DialogInterface;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.Toast;

/**
 * Class Representing Store Order Activity
 * @author Kirtan Patel
 * @author Adityaraj Gangopadhyay
 */
public class StoreOrderActivity extends AppCompatActivity {

    private ListView storeOrderListView;

    private StoreOrder storeOrder = StoreOrder.getInstance();

    /**
     * onCreate method to start the activity/view.
     * @param savedInstanceState Bundle of savedInstance.
     */
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_storeorders);

        storeOrderListView = findViewById(R.id.store_order_list_view);


        StoreOrderAdapter adapter = new StoreOrderAdapter(this, storeOrder.getOrders());
        storeOrderListView.setAdapter(adapter);

        storeOrderListView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                showRemoveItemDialog(position);
            }
        });
    }

    /**
     * Show Alert Dialog for when Remove Is Initiated.
     * @param position int position of clicked on order.
     */
    private void showRemoveItemDialog(final int position) {
        AlertDialog.Builder builder = new AlertDialog.Builder(this);
        builder.setTitle("Remove Order");
        builder.setMessage("Do you want to remove this item from Store order?");
        builder.setCancelable(false);
        builder.setPositiveButton("Remove", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                storeOrder.removeOrder(position);
                ((StoreOrderAdapter) storeOrderListView.getAdapter()).notifyDataSetChanged();
                Toast.makeText(StoreOrderActivity.this, "Order Removed",
                        Toast.LENGTH_SHORT).show();
            }
        });
        builder.setNegativeButton("Cancel", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                dialog.dismiss();
                Toast.makeText(StoreOrderActivity.this, "Order Not Removed",
                        Toast.LENGTH_SHORT).show();
            }
        });

        AlertDialog alertDialog = builder.create();
        alertDialog.show();

    }
}
