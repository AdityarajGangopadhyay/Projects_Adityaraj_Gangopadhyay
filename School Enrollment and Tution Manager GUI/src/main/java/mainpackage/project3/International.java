package mainpackage.project3;

/**
 * International class meant to represent an international student.
 * Extends the NonResident class by representing whether in Study abroad.
 * @author Adityaraj Gangopadhyay
 */
public class International extends NonResident {
    private boolean isStudyAbroad;

    private static int MAX_CREDITS_ENROLLED_STUDY_ABROAD = 12;
    private static int MIN_CREDITS_ENROLLED_INTERNATIONAL = 12;
    private static double HEALTH_INSURANCE_FEE = 2650;

    /**
     * Constructor for the NonResident class.
     * @param isStudyAbroad   Represents wether in Study Abroad.
     * @param profile         Profile class for the student.
     * @param major           Student's Major enum.
     * @param creditCompleted Amount of credits completed by student.
     */
    public International(Profile profile, Major major, int creditCompleted,
                         boolean isStudyAbroad) {
        super(profile, major, creditCompleted);
        this.isStudyAbroad = isStudyAbroad;
    }

    /**
     * Getter method for boolean isStudyAbroad.
     * @return isStudyAbroad.
     */
    public boolean getisStudyAbroad(){
        return this.isStudyAbroad;
    }
    /**
     * Override says wether international student has valid credits enrolled.
     * @param creditEnrolled int representing credits to be enrolled.
     * @return true if valid, false otherwise.
     */
    @Override
    public boolean isValid(int creditEnrolled) {
        if (isStudyAbroad) {
            if (creditEnrolled > MAX_CREDITS_ENROLLED_STUDY_ABROAD ||
                    creditEnrolled < MIN_CREDITS_ENROLLED) {
                return false;
            }
            else {
                return true;
            }
        }
        else {
            if (creditEnrolled > MAX_CREDITS_ENROLLED ||
                    creditEnrolled < MIN_CREDITS_ENROLLED_INTERNATIONAL) {
                return false;
            }
            else{
                return true;
            }
        }
    }

    /**
     * Override method to calculate tuition for International Student.
     * @param creditsEnrolled int representing credits to be enrolled.
     * @return double representing tuition due for Student.
     */
    @Override
    public double tuitionDue(int creditsEnrolled) {
        double tuition;
        if(isStudyAbroad){
            tuition = UNIVERSITY_FEE_FULLTIME + HEALTH_INSURANCE_FEE;
            return tuition;
        }
        else{
            if(creditsEnrolled < MIN_CREDITS_ENROLLED_FULLTIME){
                tuition = (NONRESIDENT_PER_CREDIT_HOUR_PRICE *
                        creditsEnrolled) + UNIVERSITY_FEE_PARTTIME;
            }
            else if(creditsEnrolled > FULLTIME_TUITION_CREDIT_CUTOFF){
                tuition = NONRESIDENT_TUITION + UNIVERSITY_FEE_FULLTIME +
                        ((creditsEnrolled - FULLTIME_TUITION_CREDIT_CUTOFF) *
                                NONRESIDENT_PER_CREDIT_HOUR_PRICE);
            }
            else{
                tuition = NONRESIDENT_TUITION + UNIVERSITY_FEE_FULLTIME;
            }
        }
        return tuition + HEALTH_INSURANCE_FEE;
    }

    /**
     * toString method for International class.
     * @return order: Profile, Major, credits completed,
     * international-Study or not.
     */
    @Override
    public String toString(){
        if(isStudyAbroad){
            return super.toString() + "(international:study abroad)";
        }
        return super.toString() + "(international)";
    }

    /**
     * Returns wether Student is international.
     * @return True for this class.
     */
    @Override
    public boolean isInternational(){
        return true;
    }
}
