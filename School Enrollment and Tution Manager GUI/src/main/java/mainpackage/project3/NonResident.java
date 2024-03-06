package mainpackage.project3;

/**
 * NonResident class meant to represent a nonresident student.
 * Extends the Student class and will be further extended.
 * @author Adityaraj Gangopadhyay
 */
public class NonResident extends Student {
    /**
     * Constructor for the NonResident class.
     * @param profile         Profile class for the student.
     * @param major           Student's Major enum.
     * @param creditCompleted Amount of credits completed by student.
     */
    public NonResident(Profile profile, Major major, int creditCompleted) {
        super(profile, major, creditCompleted);
    }

    /**
     * Abstract class to be implemented in Subclasses.
     * @param creditsEnrolled int representing credits to be enrolled.
     * @return double representing tuition due for Student.
     */
    @Override
    public double tuitionDue(int creditsEnrolled){
        double tuition;
        if(creditsEnrolled < MIN_CREDITS_ENROLLED_FULLTIME){
            tuition = (NONRESIDENT_PER_CREDIT_HOUR_PRICE * creditsEnrolled) +
                    UNIVERSITY_FEE_PARTTIME;
        }
        else if(creditsEnrolled > FULLTIME_TUITION_CREDIT_CUTOFF){
            tuition = NONRESIDENT_TUITION + UNIVERSITY_FEE_FULLTIME +
                    ((creditsEnrolled - FULLTIME_TUITION_CREDIT_CUTOFF) *
                            NONRESIDENT_PER_CREDIT_HOUR_PRICE);
        }
        else{
            tuition = NONRESIDENT_TUITION + UNIVERSITY_FEE_FULLTIME;
        }
        return tuition;
    }

    /**
     * Returns whether Student is international.
     * @return False for this class.
     */
    public boolean isInternational(){
        return false;
    }

    /**
     * Returns whether Student is from Tri State.
     * @return False for this class.
     */
    public boolean isTriState(){
        return false;
    }

    /**
     * Overridden method returns whether student is Resident.
     * @return false since student is nonresident.
     */
    @Override
    public boolean isResident() {
        return false;
    }

    /**
     * toString method for Nonresident class.
     * @return order of: Profile, Major, credits completed, nonresident.
     */
    @Override
    public String toString(){
        return super.toString() + "(non-resident)";
    }
}
