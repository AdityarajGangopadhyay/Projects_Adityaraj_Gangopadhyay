package mainpackage.project3;

/**
 * Enrollment Class to hold the list of Students who are enrolled in classes this semester.
 * @author KirtanKumar Patel
 * @author Adityaraj Gangopadhyay
 */
public class Enrollment {
    private EnrollStudent[] enrollStudents;
    private int size;


    public static final int INCREMENT_SIZE = 4;

    /**
     * Constructor for Enrollment Class
     */
    public Enrollment() {
        this.enrollStudents = new EnrollStudent[INCREMENT_SIZE];
        this.size = 0;
    }

    /**
     * getter method for size
     * @return Int representing amount of students in Enrollment array
     */
    public int getSize() {
        return this.size;
    }

    /**
     * getter method for Enrollment class
     * @return  Enroll Student arrau carrying the students
     */
    public EnrollStudent[] getEnrollStudents() {
        return this.enrollStudents;
    }

    /**
     *  grow method for the enrollment class. Increases Student array Length by 4.
     */
    private void grow() {
        EnrollStudent[] newStudents = new EnrollStudent[
                this.enrollStudents.length + INCREMENT_SIZE];
        for (int i = 0; i < this.size; i++) {
            newStudents[i] = this.enrollStudents[i];
        }
        this.enrollStudents = newStudents;
    }

    /**
     * add method for the Enrollment class.
     *@param enrollStudent adding the student to the end of the Array.
     */
    public void add(EnrollStudent enrollStudent) {
        if (contains(enrollStudent)) { //No Print Statements allowed here.
            //System.out.println("Student is already in Enrollment");
        }
        if (this.size == this.enrollStudents.length) {
            grow();
        }
        this.enrollStudents[this.size++] = enrollStudent;

    }

    /**
     * remove method for the Enrollment Class
     *@param enrollStudent  enroll student to be searched and removed.
     */
    public void remove(EnrollStudent enrollStudent) {
        int index = 0;
        for (int i = 0; i < this.size; i++) {
            if (this.enrollStudents[i] == null) {
                //System.out.println("Not Found");
            }
            if (this.enrollStudents[i].equals(enrollStudent)) {
                index = i;
            }
        }
        this.enrollStudents[index] = this.enrollStudents[size - 1];
        this.enrollStudents[size - 1] = null;
        this.size--;
    }

    /**
     * Checks if the Enroll Student is already in the Roster.
     * @param enrollStudent Student to be checked.
     * @return  true if contains, false otherwise.
     */
    public boolean contains(EnrollStudent enrollStudent) {
        return this.find(enrollStudent) != -1;
    }

    /**
     * Checks if the Enroll Student is already is in the Roster.
     * @param enrollStudent Student to be checked.
     * @return  int index of Student if found, -1 if not found.
     */
    public int find(EnrollStudent enrollStudent) {
        for (int i = 0; i < this.size; i++) {
            if (this.enrollStudents[i] == null) {
                //System.out.println("Not Found");
            } else if (this.enrollStudents[i].getProfile().equals(
                    enrollStudent.getProfile())) {
                return i;
            }
        }
        return -1;
    }

    /**
     * Prints the Enrolled Student is without sorting
     */
    public String print() {
        StringBuilder stringBuilder = new StringBuilder();
        if(this.size == 0){
            stringBuilder.append("Enrollment is empty!\n");
            return stringBuilder.toString();
        }
        stringBuilder.append("** Enrollment **\n");
        for (int i = 0; i < this.size; i++) {
            stringBuilder.append(this.enrollStudents[i].toString() + "\n");
        }
        stringBuilder.append("* end of enrollment *\n");
        return stringBuilder.toString();
    }

    /**
     * Getter method to get creditsEnrolled
     * @param student   Student object
     * @return  Number of credits Enrolled by the student.
     */
    public int getCreditsEnrolled(Student student){
        int creditsEnrolled = 0;
        for(EnrollStudent enrollStudent : this.enrollStudents ){
            if(enrollStudent != null && enrollStudent.getProfile().equals(student.getProfile())){
                creditsEnrolled += enrollStudent.getCreditsEnrolled();
            }
        }
        return creditsEnrolled;
    }

}
