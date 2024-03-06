package mainpackage.project3;

/**
 * Profile class for a student profile.
 * Comprised of first and last name, and date of birth.
 * @author Adityaraj Gangopadhyay
 */
public class Profile implements Comparable<Profile> {
    private String lname;
    private String fname;
    private Date dob;

    private static final int EQUAL = 0;
    private static final int LESS_THAN = -1;
    private static final int MORE_THAN = 1;

    /**
     * Constructor for Profile class.
     * @param fname firstname
     * @param lname lastname
     * @param dob date of birth
     */
    public Profile(String fname, String lname, Date dob){
        this.fname = fname;
        this.lname = lname;
        this.dob = dob;
    }

    /**
     * toString method for Profile class.
     * @return String in the order of Lastname, Firstname, Date of Birth.
     */
    @Override
    public String toString(){
        String date = this.dob.toString();
        return this.fname + " " + this.lname + " " + date;
    }

    /**
     * Checks if two Profiles are identical.
     * @param profile Profile object which will be compared.
     * @return True if identical, false otherwise.
     */
    @Override
    public boolean equals(Object profile){
        Profile castProfile = (Profile) profile;
        return this.fname.equalsIgnoreCase(castProfile.fname)
                && this.lname.equalsIgnoreCase(castProfile.lname)
                && this.dob.equals(castProfile.dob);
    }

    /**
     * compareTo method for the Profile class.
     * Ordered by last name, first name, and DOB.
     * @param profile the Profile object to be compared.
     * @return 0 if equal, -1 if less, 1 if more.
     */
    @Override
    public int compareTo(Profile profile) {
        if(this.equals(profile)) {
            return EQUAL;
        }

        if(this.lname.compareToIgnoreCase(profile.lname) == EQUAL){
            if(this.fname.compareToIgnoreCase(profile.fname) == EQUAL){
                if(this.dob.compareTo(profile.dob) == LESS_THAN){
                    return LESS_THAN;
                }
                else{
                    return MORE_THAN;
                }
            }
            else if(this.fname.compareToIgnoreCase((profile.fname)) < EQUAL){
                return LESS_THAN;
            }
            else{
                return MORE_THAN;
            }
        }
        else if(this.lname.compareToIgnoreCase(profile.lname) < EQUAL){
            return LESS_THAN;
        }
        else{
            return MORE_THAN;
        }
    }
}
