package mainpackage.project3;

/**
 * TriState class meant to represent a TriState student.
 * Extends the NonResident class by consisting of state name.
 * @author Adityaraj Gangopadhyay
 */
public class TriState extends NonResident{
    private String state;

    private static double CONNECTICUT_DISCOUNT = 5000;
    private static double NEW_YORK_DISCOUNT = 4000;

    /**
     * Constructor for the TriState class.
     * @param state           String representing state.
     * @param profile         Profile class for the student.
     * @param major           Student's Major enum.
     * @param creditCompleted Amount of credits completed by student.
     */
    public TriState(Profile profile, Major major, int creditCompleted, String state) {
        super(profile, major, creditCompleted);
        this.state = state;
    }

    /**
     * Getter method for state name.
     * @return State name in String Upper Case.
     */
    public String getState(){
        return this.state.toUpperCase();
    }

    /**
     * Override method to calculate tuition due for current TriState Student.
     * @param creditsEnrolled int representing credits to be enrolled.
     * @return double representing tuition due for Student.
     */
    @Override
    public double tuitionDue(int creditsEnrolled) {
        double tuition;
        if(creditsEnrolled < MIN_CREDITS_ENROLLED_FULLTIME){
            tuition = (NONRESIDENT_PER_CREDIT_HOUR_PRICE * creditsEnrolled) +
                    UNIVERSITY_FEE_PARTTIME;
            return tuition;
        }
        else if(creditsEnrolled > FULLTIME_TUITION_CREDIT_CUTOFF){
            tuition = NONRESIDENT_TUITION + UNIVERSITY_FEE_FULLTIME +
                    ((creditsEnrolled - FULLTIME_TUITION_CREDIT_CUTOFF) *
                            NONRESIDENT_PER_CREDIT_HOUR_PRICE);
        }
        else{
            tuition = NONRESIDENT_TUITION + UNIVERSITY_FEE_FULLTIME;
        }

        if(this.state.equalsIgnoreCase("CT")){
            return tuition - CONNECTICUT_DISCOUNT;
        }
        else{
            return tuition - NEW_YORK_DISCOUNT;
        }
    }

    /**
     * toString method for TriState class.
     * @return order of: Profile, Major, credits completed, nonresident
     * and state.
     */
    @Override
    public String toString(){
        return super.toString() + "(tri-state:" + this.state.toUpperCase() +
                ")";
    }

    /**
     * Returns wether Student is from Tri State.
     * @return True for this class.
     */
    @Override
    public boolean isTriState(){
        return true;
    }
}
