package mainpackage.project3;

/**
 * Roster class meant to handle an array of students.
 * @author Adityaraj Gangopadhyay
 * @author Kirtankumar Patel
 */
public class Roster {
    private Student[] roster;
    private int size; //Actual Amount of Students in Array;

    private static final int NOT_FOUND = -1;
    private static final int GROWTH_ENUMERATOR = 4;

    public Roster(){
        this.roster = new Student[4];
        this.size = 0;
    }

    /**
     * getter method for size.
     * @return int representing amount of Students in Roster array.
     */
    public int getSize(){
        return this.size;
    }

    /**
     * getter method for Roster class.
     * @return Student array representing the roster.
     */
    public Student[] getRoster(){
        return this.roster;
    }

    /**
     * Changes major for selected Student.
     * @param student Student which will have Major changed.
     * @param major The new Major for the selected student.
     */
    public void changeMajor(Student student, Major major){
        this.roster[find(student)].setMajor(major);
    }

    /**
     * find method for Roster class.
     * @param student Student object to be searched for in Roster array.
     * @return int index of Student if found, -1 if not found.
     */
    public int find(Student student) {
        for(int i = 0; i < this.roster.length; i++){
            if(this.roster[i] == null){
                return NOT_FOUND;
            }
            if(this.roster[i].equals(student)) {
                return i;
            }
        }
        return NOT_FOUND;
    }

    /**
     * grow method for Roster class. Increase Student array length by 4.
     */
    private void grow() {
        Student[] newRoster = new Student[this.roster.length + GROWTH_ENUMERATOR];
        for(int i = 0; i < this.roster.length; i++){
            newRoster[i] = this.roster[i];
        }
        this.roster = newRoster;
    }

    /**
     * add method for Roster class.
     * @param student Student object to be added to the end of Array.
     * @return true if successful, false otherwise.
     */
    public boolean add(Student student){
        int oldIndex = this.roster.length;
        if(this.find(student) == NOT_FOUND){
            if(this.roster[this.roster.length - 1] != null){
                this.grow();
                this.roster[oldIndex] = student;
                this.size = this.size + 1;
                return true;
            }
            for(int i = 0; i < this.roster.length; i++){
                if(roster[i] == null){
                    this.roster[i] = student;
                    this.size = this.size + 1;
                    return true;
                }
            }
        }
        return false;
    }

    /**
     * remove method for Roster class.
     * @param student student to be searched and removed.
     * @return true if successful, false otherwise.
     */
    public boolean remove(Student student){
        if(!this.contains(student)){
            return false;
        }
        boolean removed = false;
        for(int i = 0; i < this.roster.length - 1; i++){
            if(removed){
                this.roster[i] = this.roster[i + 1];
            }
            else if(this.roster[i].equals(student)){
                this.roster[i] = this.roster[i + 1];
                removed = true;
            }
        }
        this.roster[this.roster.length - 1] = null;
        this.size = this.size - 1;
        return true;
    }

    /**
     * Checks wether Student is already in the Roster.
     * @param student Student object to be checked.
     * @return true if contains, false otherwise.
     */
    public boolean contains(Student student){
        if(this.find(student) == NOT_FOUND){
            return false;
        }
        return true;
    }

    /**
     * prints Students by Profiles.
     */
    /*public void print(){
        if(roster[0] == null){
            System.out.println("Student roster is empty!");
            return;
        }
        System.out.println("** Student roster sorted by last name, first name, DOB **");
        Student temp;
        for(int i = 0; i < this.size; i++) {
            for (int j = i + 1; j < this.size; j++) {
                if(this.roster[i].compareTo(this.roster[j]) > 0){
                    temp = this.roster[i];
                    this.roster[i] = this.roster[j];
                    this.roster[j] = temp;
                }
            }
        }
        for(int i = 0; i < this.size; i++){
            System.out.println(this.roster[i].toString());
        }
        System.out.println("* end of roster *");
    }
    */

    /**
     * Prints Students by Profile
     * @return String of Students
     */
    public String print(){
        StringBuilder stringBuilder = new StringBuilder();
        if(roster[0] == null){
            stringBuilder.append("Student roster is empty!\n");
            return stringBuilder.toString();
        }
        stringBuilder.append("** Student roster sorted by last name, first name, DOB **\n");
        Student temp;
        for(int i = 0; i < this.size; i++) {
            for (int j = i + 1; j < this.size; j++) {
                if(this.roster[i].compareTo(this.roster[j]) > 0){
                    temp = this.roster[i];
                    this.roster[i] = this.roster[j];
                    this.roster[j] = temp;
                }
            }
        }
        for(int i = 0; i < this.size; i++){
            stringBuilder.append(this.roster[i].toString() + "\n");
        }
        stringBuilder.append("* end of roster *\n");
        return stringBuilder.toString();
    }
    /**
     * prints Students by School name and then Major name.
     *
     * @return
     */
    public String printBySchoolMajor() {
        StringBuilder stringBuilder = new StringBuilder();
        if(roster[0] == null){
            stringBuilder.append("Student roster is empty!\n");
            //System.out.println("Student roster is empty!");
            return stringBuilder.toString();
        }
        //System.out.println("** Student roster sorted by school, major **");
        stringBuilder.append("** Student roster sorted by school, major **\n");
        Student temp;
        for(int i = 0; i < this.size; i++) {
            for (int j = i + 1; j < this.size; j++) {
                if(this.roster[i].getMajor().getSchool().compareTo(
                        this.roster[j].getMajor().getSchool()) > 0){
                    temp = this.roster[i];
                    this.roster[i] = this.roster[j];
                    this.roster[j] = temp;
                }
                else if(this.roster[i].getMajor().getSchool().compareTo(
                        this.roster[j].getMajor().getSchool()) == 0){
                    if(this.roster[i].getMajor().getMajorString().compareTo(
                            this.roster[j].getMajor().getMajorString()) > 0){
                        temp = this.roster[i];
                        this.roster[i] = this.roster[j];
                        this.roster[j] = temp;
                    }
                }
            }
        }
        for(int i = 0; i < this.size; i++){
            stringBuilder.append(this.roster[i].toString() +"\n");
            //System.out.println(this.roster[i].toString());
        }
        stringBuilder.append("* end of roster *\n");
        //System.out.println("* end of roster *");
        return stringBuilder.toString();
    }

    /**
     * prints Students by Standing name.
     * @return String of list.
     */
    public String printByStanding(){
        StringBuilder stringBuilder = new StringBuilder();
        if(roster[0] == null){
            //System.out.println("Student roster is empty!");
            stringBuilder.append("Student roster is empty!\n");
            return stringBuilder.toString();
        }
        stringBuilder.append("** Student roster sorted by standing **\n");
        Student temp;
        for(int i = 0; i < this.size; i++) {
            for (int j = i + 1; j < this.size; j++) {
                if(this.roster[i].getStanding().compareTo(
                        this.roster[j].getStanding()) > 0){
                    temp = this.roster[i];
                    this.roster[i] = this.roster[j];
                    this.roster[j] = temp;
                }
            }
        }
        for(int i = 0; i < this.size; i++){
            stringBuilder.append(this.roster[i].toString() + "\n");
            //System.out.println(this.roster[i].toString());
        }
        stringBuilder.append("* end of roster *\n");
        //System.out.println("* end of roster *");
        return stringBuilder.toString();
    }

    /**
     * getter methods for the Student array
     * @return the student array
     */
    public Student[] getStudents() {
        Student[] students = new Student[size];
        int index = 0;
        for (Student student : roster){
            if(student != null){
                students[index] = student;
                index++;
            }
        }
        return students;
    }
}

