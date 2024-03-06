package mainpackage.project3;

import java.util.Calendar;

/**
 * Date class which represents dates.
 * Comprised of birth year, month, and day.
 * @author Adityaraj Gangopadhyay
 */
public class Date implements Comparable<Date> {
    private int year;
    private int month;
    private int day;

    public static final int MONTH_ADJUSTER = 1;
    public static final int JANUARY = 1;
    public static final int FEBRUARY = 2;
    public static final int MARCH = 3;
    public static final int APRIL = 4;
    public static final int MAY = 5;
    public static final int JUNE = 6;
    public static final int JULY = 7;
    public static final int AUGUST = 8;
    public static final int SEPTEMBER = 9;
    public static final int OCTOBER = 10;
    public static final int NOVEMBER = 11;
    public static final int DECEMBER = 12;
    public static final int QUADRENNIAL = 4;
    public static final int CENTENNIAL = 100;
    public static final int QUATERCENTENNIAL = 400;
    public static final int MONTHS_IN_YEAR = 12;
    public static final int DAYS_IN_MONTHS1 = 31;
    public static final int DAYS_IN_MONTHS2 = 30;
    public static final int DAYS_FEBRUARY = 28;
    public static final int DAYS_FEBRUARY_LEAP = 29;
    public static final int VALID_AGE_CUTOFF = 16;

    private static final int EQUAL = 0;
    private static final int LESS_THAN = -1;
    private static final int MORE_THAN = 1;

    /**
     * Default Constructor for Date Class.
     * Creates Date object for today's date.
     */
    public Date() {
        Calendar currentDate = Calendar.getInstance();
        this.year = currentDate.get(Calendar.YEAR);
        this.month = currentDate.get(Calendar.MONTH) + MONTH_ADJUSTER;
        this.day = currentDate.get(Calendar.DAY_OF_MONTH);
    } //create an object with today’s date (see Calendar class)

    /**
     * Second Constructor for Date Class.
     * @param date take mm/dd/yyyy and create a Date object.
     */
    public Date(String date) {
        String[] arr = date.split("/");
        this.month = Integer.parseInt(arr[0]);
        this.day = Integer.parseInt(arr[1]);
        this.year = Integer.parseInt(arr[2]);
    }

    /**
     * Helper Method that determines whether input year is a leap year.
     * @param year int representing the year to be checked.
     * @return true if leap year, false otherwise.
     */
    private boolean isLeapYear(int year){
        if(year % QUADRENNIAL == 0){
            if(!(year % CENTENNIAL == 0)){
                return true;
            }
            if(year % QUATERCENTENNIAL == 0){
                return true;
            }
            else{
                return false;
            }
        }
        return false;
    }

    /**
     * Helper method to determine if date is 16 years old.
     * @return True is older, false otherwise.
     */
    public boolean is16(){
        Date date = new Date();
        if(date.year - this.year < VALID_AGE_CUTOFF){
            return false;
        }
        if(date.year - this.year == VALID_AGE_CUTOFF &&
                date.month < this.month){
            return false;
        }
        if(date.year - this.year == VALID_AGE_CUTOFF &&
                date.month == this.month && date.day < this.day){
            return false;
        }
        return true;
    }

    /**
     * Method that determines if given Date object is a valid calendar date.
     * Will also determine if age younger than 16.
     * @return True if valid, false otherwise.
     */
    public boolean isValid() { //**Exactly 40 Lines Excluding the method signature.
        if(this.day < 1 || this.month < 1 || this.year < 1 ||
                this.month > MONTHS_IN_YEAR){
            return false;
        }
        if(this.month == JANUARY || this.month == MARCH || this.month == MAY
                || this.month == JULY || this.month == AUGUST ||
                this.month == OCTOBER || this.month == DECEMBER){
            if(this.day > DAYS_IN_MONTHS1){
                return false;
            }
        }
        if(this.month == APRIL || this.month == JUNE ||
                this.month == SEPTEMBER || this.month == NOVEMBER){
            if(this.day > DAYS_IN_MONTHS2){
                return false;
            }
        }
        if(this.month == FEBRUARY){
            if(isLeapYear(this.year)){
                if(this.day > DAYS_FEBRUARY_LEAP){
                    return false;
                }
            }
            else if(this.day > DAYS_FEBRUARY){
                return false;
            }
        }
        return this.is16();
    }

    /**
     * toString method for Date class.
     * @return String in format "mm/dd/yyyy".
     */
    @Override
    public String toString(){
        return this.month + "/" + this.day + "/" + this.year;
    }

    /**
     * Checks if two Dates are identical.
     * @param date Date object which will be compared.
     * @return True if identical, false otherwise.
     */
    @Override
    public boolean equals(Object date){
        Date castDate = (Date) date;
        return this.month == castDate.month && this.day == castDate.day
                && this.year == castDate.year;
    }

    /**
     * compareTo method for the Date class.
     * @param date the Date object to be compared.
     * @return 0 if equal, -1 if older, 1 if more recent.
     */
    @Override
    public int compareTo(Date date) {
        if(this.equals(date)){
            return EQUAL;
        }

        if(this.year == date.year){
            if(this.month == date.month){
                if(this.day < date.day) {
                    return LESS_THAN;
                }
                else {
                    return MORE_THAN;
                }
            }
            else if(this.month < date.month){
                return LESS_THAN;
            }
            else{
                return MORE_THAN;
            }
        }
        else if(this.year < date.year) {
            return LESS_THAN;
        }
        else{
            return MORE_THAN;
        }
    }

    /**
     * Testbed main() for the isValid() method of Student Class.
     * More Info in TestSpecification.pdf.
     * Expected Output = false; 6 cases.
     * Expected Output = true; 2 cases.
     */
    public static void main(String[] args){
        Date date = new Date("2/29/2003");
        System.out.println("Test Case 1: " + date.isValid());

        date = new Date("4/31/2003");
        System.out.println("Test Case 2: " + date.isValid());

        date = new Date("13/31/2003");
        System.out.println("Test Case 3: " + date.isValid());

        date = new Date("3/32/2003");
        System.out.println("Test Case 4: " + date.isValid());

        date = new Date("-1/31/2003");
        System.out.println("Test Case 5: " + date.isValid());

        date = new Date("9/2/2022");
        System.out.println("Test Case 6: " + date.isValid());

        date = new Date("1/2/2007");
        System.out.println("Test Case 7: " + date.isValid());

        date = new Date("12/20/2004");
        System.out.println("Test Case 8: " + date.isValid());
    }
}
