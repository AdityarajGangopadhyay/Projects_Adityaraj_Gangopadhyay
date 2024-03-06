package mainpackage.project3;
/**
 * Major enum for the major of a student.
 * Comprised of major code, major abbreviation,and school abbreviation.
 * @author Adityaraj Gangopadhyay
 */
public enum Major {
    CS ("01:198", "CS", "SAS"),
    MATH ("01:640", "MATH", "SAS"),
    EE ("14:332", "EE", "SOE"),
    ITI ("04:547", "ITI", "SC&I"),
    BAIT ("33:136", "BAIT", "RBS");

    private final String code;
    private final String major;
    private final String school;

    /**
     * Constructor for Major enum.
     * @param code code for major.
     * @param school Abbreviation of school name.
     */
    Major(String code, String major, String school){
        this.code = code;
        this.major = major;
        this.school = school;
    }

    /**
     * getter method for school name.
     * @return String of school abbreviation.
     */
    public String getSchool(){
        return this.school;
    }

    /**
     * getter method for Student major.
     * @return String of Student major.
     */
    public String getMajorString(){
        return this.major;
    }

    /**
     * toString method for Major class.
     * @return in the format "(code major school)"
     */
    @Override
    public String toString(){
        return "(" + this.code + " " + this.major + " " + this.school + ")";
    }
}
