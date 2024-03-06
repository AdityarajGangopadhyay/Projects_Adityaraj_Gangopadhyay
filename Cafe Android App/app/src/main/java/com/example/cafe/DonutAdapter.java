package com.example.cafe;

import android.content.Context;
import android.graphics.Color;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.core.content.ContextCompat;
import androidx.recyclerview.widget.RecyclerView;

import java.util.List;

/**
 * Class Representing DonutAdapter Object
 * @author kirtanpatel
 */
public class DonutAdapter extends RecyclerView.Adapter<DonutAdapter.ViewHolder> {
    private List<Donut> donutList;
    private Context context;
    private OnDonutClickListener onDonutClickListener;
    private int selectedItemPosition = RecyclerView.NO_POSITION;

    private RecyclerView recyclerView;

    /**
     * Constructor for DonutAdapter Class
     * @param context context Current Context of Activity.
     * @param donutList List of Donuts for Activity.
     * @param onDonutClickListener Current onDonutClickListener for Activity/View.
     */
    public DonutAdapter(Context context, List<Donut> donutList, OnDonutClickListener
            onDonutClickListener) {
        this.donutList = donutList;
        this.context = context;
        this.onDonutClickListener = onDonutClickListener;
    }

    /**
     * Overrides and Creates the View Holder for Donut Adapter recyclerView.
     * @param parent The ViewGroup into which the new View will be added after it is bound to
     *               an adapter position.
     * @param viewType The view type of the new View.
     * @return ViewHolder for DonutAdapter.
     */
    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.donut_item, parent,
                false);
        return new ViewHolder(view);
    }

    /**
     * Overrides and binds the view holder and highlights selected donuts in the recycler view.
     * @param holder The ViewHolder which should be updated to represent the contents of the
     *        item at the given position in the data set.
     * @param position The position of the item within the adapter's data set.
     */
    @Override
    public void onBindViewHolder(@NonNull ViewHolder holder, int position) {
        Donut donut = donutList.get(position);
        holder.donutName.setText(donut.toString());
        holder.donutImage.setImageResource(changeDonutImage(donut.getType()));

        // Highlight the selected item
        if (selectedItemPosition == position) {
            holder.itemView.setBackgroundColor(ContextCompat.getColor(context,
                    android.R.color.holo_blue_light));
        } else {
            holder.itemView.setBackgroundColor(Color.TRANSPARENT);
        }
    }

    /**
     * Returns amount of items.
     * @return int of item amount.
     */
    @Override
    public int getItemCount() {
        return donutList.size();
    }

    /**
     * Returns list of Donuts.
     * @return List of Donuts.
     */
    public List<Donut> getDonutList() {
        return donutList;
    }

    /**
     * Method which calls the onDonutClick method.
     */
    public interface OnDonutClickListener {
        void onDonutClick(int position);
    }

    /**
     * Helper Method for onBindViewHolder. Helps assign images to each donut.
     * @param donutName Name of Donut.
     * @return Integer representing Donut Image.
     */
    private int changeDonutImage(String donutName){
        switch(donutName) {
            case "Jelly":
                return R.drawable.jelly_donut;
            case "Glazed":
                return R.drawable.glazed_donut;
            case "Chocolate Frosted":
                return R.drawable.chocolate_frosted_donut;
            case "Chocolate Glazed":
                return R.drawable.chocolate_glazed_donut;
            case "Strawberry Frosted":
                return R.drawable.strawberry_frosted_donut;
            case "Boston Cream":
                return R.drawable.boston_cream_donut;
            case "Cinnamon Sugar":
                return R.drawable.cinnamon_sugar_donut;
            case "Old Fashion":
                return R.drawable.old_fashion_donut;
            case "Blueberry":
                return R.drawable.blueberry_donut;
            case "ButterFingers":
                return R.drawable.butterfingers_donuthole;
            case "Nutella Churro":
                return R.drawable.nutella_churro_donuthole;
            case "Italian Cherry":
                return R.drawable.italain_cherry_donuthole;
            default:
                return R.drawable.order_donuts;
        }
    }

    /**
     * Returns selected item position.
     * @return Int representing currently selected item position.
     */
    public int getSelectedItemPosition(){
        return selectedItemPosition;
    }

    /**
     * Protected SubClass for the ViewHolder
     */
    protected class ViewHolder extends RecyclerView.ViewHolder implements View.OnClickListener {
        ImageView donutImage;
        TextView donutName;

        /**
         * Constructor for the ViewHolder.
         * @param itemView View of the item.
         */
        public ViewHolder(@NonNull View itemView) {
            super(itemView);
            donutImage = itemView.findViewById(R.id.donut_image);
            donutName = itemView.findViewById(R.id.donut_name);
            itemView.setOnClickListener(this);
        }

        /**
         * Override method for onClick on the ViewHolder.
         * @param v View of the DonutAdapter.
         */
        @Override
        public void onClick(View v) {
            int position = getAdapterPosition();
            if (position != RecyclerView.NO_POSITION) {
                if (position != selectedItemPosition) {
                    int previousSelectedItemPosition = selectedItemPosition;
                    selectedItemPosition = position;
                    notifyItemChanged(previousSelectedItemPosition);
                    notifyItemChanged(selectedItemPosition);
                    onDonutClickListener.onDonutClick(position);
                } else {
                    selectedItemPosition = RecyclerView.NO_POSITION;
                    notifyItemChanged(position);
                }
            }
        }
    }
}
