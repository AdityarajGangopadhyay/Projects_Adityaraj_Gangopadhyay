package mainpackage.project3;



/**
 * Student class meant to represent a student.
 * Comprised of a profile, major, and amount of credits completed.
 * @author Adityaraj Gangopadhyay
 */
public abstract class Student implements Comparable<Student> {
    private Profile profile;
    private Major major; //Major is an enum type
    private int creditCompleted;

    public static int MIN_CREDITS_ENROLLED_FULLTIME = 12;
    public static double RESIDENT_PER_CREDIT_HOUR_PRICE = 404;
    public static double NONRESIDENT_PER_CREDIT_HOUR_PRICE = 966;
    public static double UNIVERSITY_FEE_FULLTIME = 3268;
    public static double UNIVERSITY_FEE_PARTTIME = UNIVERSITY_FEE_FULLTIME
            * 0.8;
    public static double RESIDENT_TUITION = 12536;
    public static double NONRESIDENT_TUITION = 29737;
    public static int FULLTIME_TUITION_CREDIT_CUTOFF = 16;
    public static int MIN_CREDITS_ENROLLED = 3;
    public static int MAX_CREDITS_ENROLLED = 24;
    public static final int FRESHMAN_CUTOFF = 30;
    public static final int SOPHOMORE_CUTOFF = 60;
    public static final int JUNIOR_CUTOFF = 90;

    /**
     * Constructor for the Student class.
     * @param profile Profile class for the student.
     * @param major Student's Major enum.
     * @param creditCompleted Amount of credits completed by student.
     */
    public Student(Profile profile, Major major, int creditCompleted){
        this.profile = profile;
        this.major = major;
        this.creditCompleted = creditCompleted;
    }

    /**
     * getter method for Profile of Student.
     * @return Profile object for the Student.
     */
    public Profile getProfile(){
        return this.profile;
    }

    /**
     * Setter method for Major enum.
     * @param major Major enum to be set.
     */
    public void setMajor(Major major){
        this.major = major;
    }

    /**
     * Getter method for creditsCompleted
     * @return creditsCompleted of Student
     */
    public int getCreditCompleted() {
        return creditCompleted;
    }

    /**
     * Setter method for int creditCompleted.
     * @param creditCompleted credit to be set to.
     */
    public void setCreditCompleted(int creditCompleted){
        this.creditCompleted = creditCompleted;
    }

    /**
     * Returns standing of student.
     * @return String of Student standing based on credits completed.
     */
    public String getStanding(){
        if(creditCompleted < FRESHMAN_CUTOFF){
            return "Freshman";
        }
        else if(creditCompleted < SOPHOMORE_CUTOFF){
            return "Sophomore";
        }
        else if(creditCompleted < JUNIOR_CUTOFF){
            return "Junior";
        }
        else{
            return "Senior";
        }
    }

    /**
     * getter method for major.
     * @return Major enum for the Student.
     */
    public Major getMajor(){
        return this.major;
    }

    /**
     * toString method for Student class.
     * @return in the order of: Profile, Major, credits completed.
     */
    @Override
    public String toString(){
        String standing;

        if(creditCompleted < FRESHMAN_CUTOFF){
            standing = "(Freshman)";
        }
        else if(creditCompleted < SOPHOMORE_CUTOFF){
            standing = "(Sophomore)";
        }
        else if(creditCompleted < JUNIOR_CUTOFF){
            standing = "(Junior)";
        }
        else{
            standing = "(Senior)";
        }

        return this.profile.toString() + " " + major.toString() +
                " credits completed: " + this.creditCompleted + " " +
                standing;
    }

    /**
     * Checks if two Students are equal.
     * @param student Student object to be compared.
     * @return If the two Profiles are equal then true otherwise false.
     */
    @Override
    public boolean equals(Object student){
        Student castStudent = (Student) student;
        return this.profile.equals(castStudent.profile);
    }

    /**
     * compareTo method for the Student class.
     * Compares the Profile objects.
     * @param student the Student object whose Profile is to be compared.
     * @return 0 if equal, -1 if less, 1 if more.
     */
    @Override
    public int compareTo(Student student) {
        return this.profile.compareTo(student.profile);
    }


    public abstract boolean isResident();

    /**
     * Abstract class to be implemented in Subclasses.
     * @param creditsEnrolled int representing credits to be enrolled.
     * @return double representing tuition due for Student.
     */
    public abstract double tuitionDue(int creditsEnrolled);//polymorphism

    /**
     * Abstract class to be implemented in Subclasses.
     * @return true is student is Resident, false otherwise.
     */

    /**
     * Default isValid method for Student.
     * Checks if creditsEnrolled is ok for any general student at all.
     * To be overriden in Subclasses.
     * @param creditEnrolled int representing credits to be enrolled.
     * @return true if between 3 and 24 (inclusive), false otherwise.
     */
    public boolean isValid(int creditEnrolled){
        if(creditEnrolled > MAX_CREDITS_ENROLLED || creditEnrolled <
                MIN_CREDITS_ENROLLED){
            return false;
        }
        return true;
    }


    /*COMMENTED OUT FOR PROJECT2
    /**
     * Testbed main() for the compareTo() method of Student Class.
     * More Info in TestSpecification.pdf.
     * Expected Output = 0; 2 cases.
     * Expected Output = -1; 2 cases.
     * Expected Output = 1; 2 cases.
     *
    public static void main(String[] args){
        Student student1 = new Student(new Profile("Adityaraj",
                "Gangopadhyay", new Date("3/17/2003")), Major.CS, 60);
        Student student2 = new Student(new Profile("Adityaraj",
                "Gangopadhyay", new Date("3/17/2003")), Major.CS, 60);
        System.out.println("Test Case 1: " + student1.compareTo(student2));

        student2 = new Student(new Profile("adityaraj",
                "gangopadhyay", new Date("3/17/2003")), Major.CS, 60);
        System.out.println("Test Case 2: " + student1.compareTo(student2));

        student2 = new Student(new Profile("Bdityaraj",
                "Gangopadhyay", new Date("3/17/2003")), Major.CS, 60);
        System.out.println("Test Case 3: " + student1.compareTo(student2));

        student2 = new Student(new Profile("Adityaraj",
                "Gangopadhyay", new Date("3/17/2004")), Major.CS, 60);
        System.out.println("Test Case 4: " + student1.compareTo(student2));

        student1 = new Student(new Profile("Bdityaraj",
                "Gangopadhyay", new Date("3/17/2003")), Major.CS, 60);
        student2 = new Student(new Profile("Adityaraj",
                "Gangopadhyay", new Date("3/17/2003")), Major.CS, 60);
        System.out.println("Test Case 5: " + student1.compareTo(student2));

        student1 = new Student(new Profile("Adityaraj",
                "Gangopadhyay", new Date("3/17/2004")), Major.CS, 60);
        student2 = new Student(new Profile("Adityaraj",
                "Gangopadhyay", new Date("3/17/2003")), Major.CS, 60);
        System.out.println("Test Case 6: " + student1.compareTo(student2));
    }*/
}
