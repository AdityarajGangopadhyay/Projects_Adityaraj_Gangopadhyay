package com.example.cafe;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 * Class representing Order
 * @author kirtanpatel
 * @author Adityaraj Gangopadhyay
 */
public class Order implements Serializable {
  private List<MenuItem> items = new ArrayList<>();
  private double subtotal = 0;

  /**
   * Base Order Constructor
   */
  public Order(){
  }

  /**
   * Order Constructor
   * @param items Order Items List
   * @param subtotal Subtotal Amount
   **/
  public Order (List<MenuItem> items, double subtotal){
      this.items = new ArrayList<>(items);
      this.subtotal = subtotal;
  }

  /**
   * Method to add items to order
   * @param items  Order Items List
   */
  public void addItems(List<? extends MenuItem> items){
      this.items.addAll(items);
      for(MenuItem item : items){
          subtotal += item.itemPrice();
      }
  }

  /**
   * Method to add a single Item to order
   * @param addeditem Item to be added
   */
  public void addItem(MenuItem addeditem){
      this.items.add(addeditem);
      subtotal += addeditem.itemPrice();
  }

  /**
   * Getter Method for Items
   * @return Items
   */
  public List<MenuItem> getItems(){
      return items;
  }

  /**
   * Getter Method for Subtotal
   * @return Subtotal amount
   */
  public double getSubtotal(){

      return subtotal;
  }

  /**
   * Method to remove item
   * @param index Index to be removed
   * @return Removed Item
   */
  public MenuItem removeItem(int index){
      MenuItem removedItem = items.remove(index);
      subtotal -= removedItem.itemPrice();
      return removedItem;
  }

  /**
   * Method to clear the list
   */
  public void clear(){
      items.clear();
      subtotal = 0;
  }

}

