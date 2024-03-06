package mainpackage.project3;

/**
 * Resident class meant to represent a resident student.
 * Extends the Student class by consisting of scholarship awarded amount.
 * @author Adityaraj Gangopadhyay, Kirtankumar Patel
 */
public class Resident extends Student {
    private int scholarship;

    /**
     * Constructor for the Resident class.
     * @param scholarship     int representing scholarship awarded.
     * @param profile         Profile class for the student.
     * @param major           Student's Major enum.
     * @param creditCompleted Amount of credits completed by student.
     */
    public Resident(Profile profile, Major major, int creditCompleted, int scholarship){
        super(profile, major, creditCompleted);
        this.scholarship = scholarship;
    }

    /**
     * Override method to calculate tuition due for current Resident Student.
     * @param creditsEnrolled int representing credits to be enrolled.
     * @return double representing tuition due for Student.
     */
    @Override
    public double tuitionDue(int creditsEnrolled) {
        double tuition;
        if(creditsEnrolled < MIN_CREDITS_ENROLLED_FULLTIME){
            tuition = (RESIDENT_PER_CREDIT_HOUR_PRICE * creditsEnrolled) +
                    UNIVERSITY_FEE_PARTTIME;
        }
        else if(creditsEnrolled > FULLTIME_TUITION_CREDIT_CUTOFF){
            tuition = RESIDENT_TUITION + UNIVERSITY_FEE_FULLTIME +
                    ((creditsEnrolled - FULLTIME_TUITION_CREDIT_CUTOFF) *
                            RESIDENT_PER_CREDIT_HOUR_PRICE);
        }
        else{
            tuition = RESIDENT_TUITION + UNIVERSITY_FEE_FULLTIME;
        }
        return tuition - scholarship;
    }

    /**
     * Overridden method returns whether student is Resident.
     * @return true since student is resident.
     */
    @Override
    public boolean isResident() {
        return true;
    }

    /** Setter method to set Scholarship amount
     *
     * @param scholarship Scholarship amount
     */
    public void setScholarship(int scholarship){
        this.scholarship = scholarship;
    }



    /**
     * toString method for Resident class.
     * @return in the order of: Profile, Major, credits completed, resident.
     */
    @Override
    public String toString(){
        return super.toString() + "(resident)";
    }
}
