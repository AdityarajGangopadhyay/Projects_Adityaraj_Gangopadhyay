package mainpackage.project3;

/**
 * EnrollStudent Class to keep track of the credits enrolled by Students.
 * @author Adityaraj Gangopadhyay
 * @author Kirtankumar Patel
 */
public class EnrollStudent {
    private Profile profile;
    private int creditsEnrolled;

    /**
     *
     * @param profile Profile object from Profile Class
     * @param creditsEnrolled   Credits enrolled by the Students
     */

    public EnrollStudent(Profile profile, int creditsEnrolled){
                this.profile = profile;
                this.creditsEnrolled = creditsEnrolled;
        }

    /**
     * Getter method to get the Profile of Student
     * @return Returns the Firstname, Lastname and DOB of Student
     */
    public Profile getProfile() {
            return this.profile;
        }

    /**
     * Getter method to get the Credits Enrolled
     * @return the number of credits enrolled by student
     */
    public int getCreditsEnrolled() {
            return this.creditsEnrolled;
        }

    /**
     * To String method to return the profile and credits enrolled of Student
     * @return  Student Profile and Credits Enrolled
     */
    @Override
    public String toString(){
        return this.profile + ": credits enrolled: " + creditsEnrolled;
    }

    /**
     * Equals to method to compare objects
     * @param object    Student Object
     * @return  True if the both the objects are equal.
     */
    @Override
    public boolean equals(Object object) {
        EnrollStudent castEnrollStudent = (EnrollStudent) object;
        return this.profile.equals(castEnrollStudent.profile);
    }


}

