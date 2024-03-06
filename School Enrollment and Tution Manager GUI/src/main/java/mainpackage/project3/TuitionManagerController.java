package mainpackage.project3;

import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.control.*;
import javafx.stage.FileChooser;

import java.io.File;
import java.io.FileNotFoundException;
import java.text.DecimalFormat;
import java.time.format.DateTimeFormatter;
import java.util.Scanner;

/**
 * Main Controller for Tuition Manager.
 * @author Adityaraj Gangopadhyay
 * @author Kirtan Patel
 */
public class TuitionManagerController {

    private static final int COMMAND = 0;
    private static final int FNAME = 1;
    private static final int LNAME = 2;
    private static final int DOB = 3;
    private static final int MAJOR = 4;
    private static final int CREDIT_COMPLETED = 5;
    private static final int STATE = 6;
    private static final int STUDY_ABROAD = 6;
    public MenuItem printbyprofileButton, printbySchoolMajorButton, printbyStandingButton;
    public Button scholarshipAmountButton;
    public MenuItem printSemesterEnd;


    @FXML
    private Button dropButton, enrollButton;

    @FXML
    private TextArea rosterTextArea;
    @FXML
    private Button removeButton;
    @FXML
    private Button changemajorButton;
    @FXML
    private Button loadfromfileButton;
    @FXML
    private RadioButton nonresidentButton;
    @FXML
    private RadioButton baitButton;
    @FXML
    private RadioButton csButton;
    @FXML
    private RadioButton eceButton;
    @FXML
    private RadioButton itiButton;
    @FXML
    private RadioButton mathButton;
    @FXML
    private RadioButton residentButton;
    @FXML
    private Button addButton;
    @FXML
    private RadioButton triStateButton;
    @FXML
    private RadioButton internationalButton;
    @FXML
    private RadioButton nyButton;
    @FXML
    private RadioButton studyabroadButton;
    @FXML
    private RadioButton ctButton;

    @FXML
    private TextField firstNameField, lastNameField, creditsField, scholarshipAmount, scholarshipFN, scholarshipLN;
    @FXML
    private DatePicker dobPicker, scholarshipDOB;

    @FXML
    private ToggleGroup btGroup_Major, btGroup_Status;

    @FXML
    private TextField enrollFN, enrollLN, enrollCredit;

    @FXML
    private DatePicker enrollDOB;


    Roster roster = new Roster();
    Enrollment enrollment = new Enrollment();

    /**
     * Handles GUI for when Resident RadioButton is clicked.
     */
    @FXML
    protected void onResidentClick() {
        triStateButton.setDisable(true);
        internationalButton.setDisable(true);
        nyButton.setDisable(true);
        ctButton.setDisable(true);
        studyabroadButton.setDisable(true);
    }

    /**
     * Handles GUI for when NonResident RadioButton is clicked.
     */
    @FXML
    protected void onNonResidentClick() {
        triStateButton.setDisable(false);
        internationalButton.setDisable(false);
        if (triStateButton.isSelected()) {
            onTriStateClick();
        } else if (internationalButton.isSelected()) {
            onInternationalClick();
        }
    }

    /**
     * Handles GUI for when TriState RadioButton is clicked.
     */
    @FXML
    protected void onTriStateClick() {
        nyButton.setDisable(false);
        ctButton.setDisable(false);
        studyabroadButton.setDisable(true);
    }

    /**
     * Handles GUI for when International RadioButton is clicked.
     */
    @FXML
    protected void onInternationalClick() {
        nyButton.setDisable(true);
        ctButton.setDisable(true);
        studyabroadButton.setDisable(false);
    }

    /**
     * Helper method to print errors in Date.
     * @param date DOB
     * @param dob DOB in String.
     */
    private void dateErrorPrint(Date date, String dob) {
        if (!date.is16()) {
            rosterTextArea.appendText("DOB invalid: " + dob + " younger than 16 years old.\n");
        } else {
            rosterTextArea.appendText("DOB invalid: " + dob + " not a valid calendar date!\n");
        }
    }

    /**
     * Handles the Click of the add button.
     * @param actionEvent
     */
    @FXML
    protected void onAddClick(ActionEvent actionEvent) {
        if (firstNameField.getText().isEmpty() || lastNameField.getText().isEmpty() ||
                dobPicker.getValue() == null || creditsField.getText().isEmpty()) {
            rosterTextArea.appendText("Missing Input(s)\n");
            return;
        }
        try {
            String dob = dobPicker.getValue().format(DateTimeFormatter.ofPattern("MM/dd/yyyy"));
            Date date = new Date(dobPicker.getValue().format(DateTimeFormatter.ofPattern("MM/dd/yyyy")));
            if (!date.isValid()) {
                dateErrorPrint(date, dob);
                return;
            }
            boolean isStudyAbroad = false;
            int creditsCompleted = Integer.parseInt(creditsField.getText());
            Profile profile = new Profile(firstNameField.getText(), lastNameField.getText(), date);
            if (residentButton.isSelected()) {
                Resident student = new Resident(profile, null, creditsCompleted, 0);
                finalAdder(roster, student, btGroup_Major);
            } else if (nonresidentButton.isSelected()) {
                NonResident student = new NonResident(profile, null, creditsCompleted);
                finalAdder(roster, student, btGroup_Major);
            } else if (triStateButton.isSelected()) {
                if (nyButton.isSelected()) {
                    TriState student = new TriState(profile, null, creditsCompleted, "NY");
                    finalAdder(roster, student, btGroup_Major);
                } else if (ctButton.isSelected()) {
                    TriState student = new TriState(profile, null, creditsCompleted, "CT");
                    finalAdder(roster, student, btGroup_Major);
                }
            } else if (internationalButton.isSelected()) {
                if (studyabroadButton.isSelected()) {
                    isStudyAbroad = true;
                }
                International student = new International(profile, null, creditsCompleted, isStudyAbroad);
                finalAdder(roster, student, btGroup_Major);
            }
        } catch (Exception e) {
            rosterTextArea.appendText("Credits completed invalid: not an integer!\n");
        }
    }

    /**
     * Helper method for onAddClick
     * @param roster     The student roster
     * @param student    The student object to be added
     * @param majorgroup The major of the student
     */
    public void finalAdder(Roster roster, Student student, ToggleGroup majorgroup) {
        if (roster.contains(student)) {
            rosterTextArea.appendText(student.getProfile().toString() + " is already in the roster.\n");
            return;
        }
        if (student.getCreditCompleted() < 0) {
            rosterTextArea.appendText("Credits completed invalid: cannot be negative!\n");
            return;
        }
        RadioButton selectedMajorButton = (RadioButton) majorgroup.getSelectedToggle();
        String major = selectedMajorButton.getText();
        switch (major) {
            case "CS":
                student.setMajor(Major.CS);
                break;
            case "MATH":
                student.setMajor(Major.MATH);
                break;
            case "EE":
                student.setMajor(Major.EE);
                break;
            case "ITI":
                student.setMajor(Major.ITI);
                break;
            case "BAIT":
                student.setMajor(Major.BAIT);
                break;
        }
        roster.add(student);
        rosterTextArea.appendText(student.getProfile().toString() + " added to the roster.\n");
    }

    /**
     * Handles the Click of the remove button.
     * @param actionEvent
     */
    @FXML
    protected void onRemoveClick(ActionEvent actionEvent) {
        if (firstNameField.getText().isEmpty() || lastNameField.getText().isEmpty() || dobPicker.getValue() == null) {
            rosterTextArea.appendText("Missing Input(s)\n");
            return;
        }
        String firstName = firstNameField.getText();
        String lastName = lastNameField.getText();
        String dob = dobPicker.getValue().format(DateTimeFormatter.ofPattern("MM/dd/yyyy"));
        Date date = new Date(dob);

        Profile profile = new Profile(firstName, lastName, date);
        Resident student = new Resident(profile, null, 0, 0);
        if (roster.contains(student)) {
            roster.remove(student);
            rosterTextArea.appendText(profile.toString() + " removed from the roster.\n");
        } else {
            rosterTextArea.appendText(profile.toString() + " is not in the roster.\n");
        }
    }

    /**
     * Handles the Click of the change major button.
     * @param actionEvent
     */
    @FXML
    protected void onChangeMajorClick(ActionEvent actionEvent) {
        if (firstNameField.getText().isEmpty() || lastNameField.getText().isEmpty() || dobPicker.getValue() == null) {
            rosterTextArea.appendText("Missing Input(s)\n");
            return;
        }
        String firstName = firstNameField.getText();
        String lastName = lastNameField.getText();
        String dob = dobPicker.getValue().format(DateTimeFormatter.ofPattern("MM/dd/yyyy"));
        Date date = new Date(dob);

        Profile profile = new Profile(firstName, lastName, date);
        Resident student = new Resident(profile, null, 0, 0);
        if (!roster.contains(student)) {
            rosterTextArea.appendText( profile.toString() + " is not in the roster.\n");
            return;
        }
        RadioButton selectedMajorButton = (RadioButton) btGroup_Major.getSelectedToggle();
        String major = selectedMajorButton.getText();

        switch (major) {
            case "CS":
                roster.getRoster()[roster.find(student)].setMajor(Major.CS);
                break;
            case "MATH":
                roster.getRoster()[roster.find(student)].setMajor(Major.MATH);
                break;
            case "EE":
                roster.getRoster()[roster.find(student)].setMajor(Major.EE);
                break;
            case "ITI":
                roster.getRoster()[roster.find(student)].setMajor(Major.ITI);
                break;
            case "BAIT":
                roster.getRoster()[roster.find(student)].setMajor(Major.BAIT);
                break;
        }
        rosterTextArea.appendText(profile.toString() + " major changed to " + major + "\n");
    }

    /**
     * Helper method for loading list.
     * @param student Student in list.
     * @param inputs Student info.
     */
    protected void loadHelper(Student student, String[] inputs) {
        if (inputs[MAJOR].equalsIgnoreCase("CS")) {
            student.setMajor(Major.CS);
        } else if (inputs[MAJOR].equalsIgnoreCase("MATH")) {
            student.setMajor(Major.MATH);
        } else if (inputs[MAJOR].equalsIgnoreCase("EE")) {
            student.setMajor(Major.EE);
        } else if (inputs[MAJOR].equalsIgnoreCase("ITI")) {
            student.setMajor(Major.ITI);
        } else {
            student.setMajor(Major.BAIT);
        }
        student.setCreditCompleted(Integer.parseInt(inputs[
                CREDIT_COMPLETED]));
        roster.add(student);
    }

    /**
     * Handles the Click of the load from file button.
     * @param actionEvent
     */
    @FXML
    protected void onLoadFromFileClick(ActionEvent actionEvent) {
        FileChooser fileChooser = new FileChooser();
        fileChooser.setTitle("Open Student List File");
        fileChooser.getExtensionFilters().add(new FileChooser.ExtensionFilter("Text Files", "*.txt"));
        File file = fileChooser.showOpenDialog(null);
        if (file != null) {
            try {
                if(!file.getName().equals("studentList.txt")){
                    rosterTextArea.appendText("Incorrect txt file.\n");
                    return;
                }
                Scanner scanner = new Scanner(file);
                while (scanner.hasNext()) {
                    String line = scanner.nextLine();
                    String[] inputs = line.split(",");
                    String status = inputs[COMMAND];
                    Date date = new Date(inputs[DOB]);
                    Student student = null;
                    switch (status) {
                        case "R":
                            student = new Resident(new Profile(inputs[FNAME], inputs[LNAME],
                                    date), null, 0, 0);
                            break;
                        case "N":
                            student = new NonResident(new Profile(inputs[FNAME], inputs[LNAME], date),
                                    null, 0);
                            break;
                        case "T":
                            student = new TriState(new Profile(inputs[FNAME], inputs[LNAME], date),
                                    null, 0, inputs[STATE]);
                            break;
                        case "I":
                            student = new International(new Profile(inputs[FNAME], inputs[LNAME], date), null,
                                    0, Boolean.parseBoolean(inputs[STUDY_ABROAD]));
                            break;
                    }
                    loadHelper(student, inputs);
                }
                rosterTextArea.appendText("Students loaded to the roster.\n");
            } catch (FileNotFoundException e) {rosterTextArea.appendText("File not Found\n");}
        }
    }

    /**
     * Helper Method prints Invalid Credit Prompt.
     * @param actual          actual Student from Roster.
     * @param creditsEnrolled number of credits the student is enrolled in.
     */
    private void InvalidCreditPrint(Student actual, int creditsEnrolled) {
        if (actual.isResident()) {
            rosterTextArea.appendText("(Resident) " + creditsEnrolled + ": invalid credit hours.");
            rosterTextArea.appendText("\n");
        } else {
            NonResident student = (NonResident) actual;
            if (student.isInternational()) {
                International last = (International) actual;
                if (last.getisStudyAbroad()) {
                    rosterTextArea.appendText("(International studentstudy abroad) " + creditsEnrolled +
                            ": invalid credit hours.");
                    rosterTextArea.appendText("\n");
                } else {
                    rosterTextArea.appendText("(International student) " + creditsEnrolled + ": invalid credit hours.");
                    rosterTextArea.appendText("\n");
                }
            } else {
                rosterTextArea.appendText("(Non-Resident) " + creditsEnrolled + ": invalid credit hours.");
                rosterTextArea.appendText("\n");
            }
        }
    }

    /**
     * Adds the student to the enrollment list.
     * @param enrollment Student enrollment.
     * @param roster Student Roster.
     * @param fn Student First Name.
     * @param ln Student Last Name.
     * @param credit Student's credit enrolled.
     * @param dob Student date of birth.
     */
    private void addEnrollment(Enrollment enrollment, Roster roster, String fn, String ln, String credit, String dob) {
        Date date = new Date(dob);
        Profile profile = new Profile(fn, ln, date);
        Student genericstudent = new Resident(profile, null, 0, 0);
        if (roster.contains(genericstudent)) {
            Student actual = roster.getRoster()[roster.find(genericstudent)];
            int creditsEnrolled;
            try {
                creditsEnrolled = Integer.parseInt(
                        credit);
            } catch (NumberFormatException nfe) {
                rosterTextArea.appendText("Credits enrolled is not an integer.");
                rosterTextArea.appendText("\n");
                return;
            }
            if (actual.isValid(creditsEnrolled)) {
                EnrollStudent enrollStudent = new EnrollStudent(profile, creditsEnrolled);
                if (enrollment.contains(enrollStudent)) {
                    enrollment.getEnrollStudents()[enrollment.find(enrollStudent)] = enrollStudent;
                } else {
                    enrollment.add(enrollStudent);
                }
                rosterTextArea.appendText(profile.toString() + " enrolled " + creditsEnrolled + " credits");
                rosterTextArea.appendText("\n");
            } else {
                InvalidCreditPrint(actual, creditsEnrolled);
            }
        } else {
            rosterTextArea.appendText("Cannot enroll: " + profile.toString() + " is not in the roster.");
            rosterTextArea.appendText("\n");
        }
    }

    /**
     * Handles Enroll Button Click.
     */
    @FXML
    protected void onEnrollClick() {
        if (enrollFN.getText().isEmpty() || enrollLN.getText().isEmpty() ||
                enrollCredit.getText().isEmpty() || enrollDOB.getValue() == null) {
            rosterTextArea.appendText("Missing Input(s)");
            rosterTextArea.appendText("\n");
            return;
        }
        addEnrollment(enrollment, roster, enrollFN.getText(), enrollLN.getText(), enrollCredit.getText(), enrollDOB.getValue().format(DateTimeFormatter.ofPattern("MM/dd/yyyy")));
    }

    /**
     * Method to drop Student from Enrollment.
     *
     * @param enrollment Student enrollment.
     * @param fn         First Name
     * @param ln         Last Name
     * @param dob        Student DOB
     */
    private void dropEnrollment(Enrollment enrollment, String fn, String ln, String dob) {
        Profile profile = new Profile(fn, ln, new Date(dob));
        EnrollStudent enrollStudent = new EnrollStudent(profile, 0);
        if (enrollment.contains(enrollStudent)) {
            enrollment.remove(enrollStudent);
            rosterTextArea.appendText(profile.toString() + " dropped.");
            rosterTextArea.appendText("\n");
        } else {
            rosterTextArea.appendText(profile.toString() + " is not enrolled.");
            rosterTextArea.appendText("\n");
        }
    }

    /**
     * Handles Drop Button Click.
     */
    @FXML
    protected void onDropClick() {
        if (enrollFN.getText().isEmpty() || enrollLN.getText().isEmpty() || enrollDOB.getValue() == null) {
            rosterTextArea.appendText("Missing Input(s)");
            rosterTextArea.appendText("\n");
            return;
        }
        DateTimeFormatter DateTimeFormatter = null;
        dropEnrollment(enrollment, enrollFN.getText(), enrollLN.getText(),
                enrollDOB.getValue().format(DateTimeFormatter.ofPattern("MM/dd/yyyy")));
    }

    /**
     * Awards scholarship to student.
     * @param roster Student roster.
     * @param profile Student profile.
     * @param student Student object.
     * @param index Index of Student.
     * @param enrollment Student enrollment.
     * @param scholarshipS Scholarship amount to be awarded.
     */
    private void scholarshipHelper(Roster roster, Profile profile, Student
            student, int index, Enrollment enrollment, String scholarshipS) {
        int scholarship;
        if (roster.contains(student)) {
            EnrollStudent enrollStudent = new EnrollStudent(profile, 0);
            int enrollIndex = enrollment.find(enrollStudent);
            if (enrollIndex != -1) {
                if (enrollment.getEnrollStudents()[enrollIndex].getCreditsEnrolled() >= 12) {
                    try {
                        scholarship = Integer.parseInt(scholarshipS);
                    } catch (NumberFormatException nfe) {
                        rosterTextArea.appendText("Amount is not an integer.\n");
                        return;
                    }
                    if (scholarship > 0 && scholarship <= 10000) {
                        Resident resident = (Resident) roster.getRoster()[
                                index];
                        resident.setScholarship(scholarship);
                        rosterTextArea.appendText(profile.toString() + ": scholarship amount updated.\n");
                    } else {
                        rosterTextArea.appendText(scholarship + ": invalid amount.\n");
                    }
                } else {
                    rosterTextArea.appendText(profile.toString() + " part time " +
                            "student is not eligible for the scholarship.\n");
                }
            }
        } else {
            rosterTextArea.appendText(profile.toString() + " is not in the roster.\n");
        }
    }

    /**
     * Handles scholarship button click.
     */
    @FXML
    protected void onScholarshipClick() {
        if (scholarshipFN.getText().isEmpty() || scholarshipLN.getText().isEmpty() ||
                scholarshipDOB.getValue() == null || scholarshipAmount.getText().isEmpty()) {
            rosterTextArea.appendText("Missing Input(s)\n");
            return;
        }
        Profile profile = new Profile(scholarshipFN.getText(), scholarshipLN.getText(),
                new Date(scholarshipDOB.getValue().format(DateTimeFormatter.ofPattern("MM/dd/yyyy"))));
        int index = roster.find(new Resident(profile, null, 0, 0));
        if (roster.contains(new Resident(profile, null, 0, 0))) {
            Student student = roster.getRoster()[index];
            if (student.isResident()) {
                scholarshipHelper(roster, profile, student, index, enrollment, scholarshipAmount.getText());
            } else {
                rosterTextArea.appendText(profile.toString());
                NonResident nonResident = (NonResident) student;
                if (nonResident.isInternational()) {
                    International international = (International)
                            nonResident;
                    if (international.getisStudyAbroad()) {
                        rosterTextArea.appendText(" (International student) is not eligible for the scholarship.\n");
                    } else {
                        rosterTextArea.appendText(" (International student study abroad) is not eligible for " +
                                "the scholarship.\n");
                    }
                } else {
                    rosterTextArea.appendText(" (Non-Resident) is not eligible for the scholarship.\n");
                }
            }
        } else {
            rosterTextArea.appendText(profile.toString() + " is not in the roster.\n");
        }
    }

    /**
     * Handles print by profile button click.
     * @param actionEvent
     */
    @FXML
    protected void onPrintProfileClick(ActionEvent actionEvent) {
        rosterTextArea.appendText(roster.print());

    }

    /**
     * Handles print by school/major button click.
     * @param actionEvent
     */
    @FXML
    protected void onPrintbySchoolMajorClick(ActionEvent actionEvent) {
        rosterTextArea.appendText(roster.printBySchoolMajor());
    }

    /**
     * Handles print by standing button click.
     * @param actionEvent
     */
    @FXML
    protected void onPrintbyStandingClick(ActionEvent actionEvent) {
        rosterTextArea.appendText(roster.printByStanding());
    }

    /**
     * Handles print by profile school options.
     * @param actionEvent
     */
    @FXML
    protected void onSchoolSelected(ActionEvent actionEvent) {
        MenuItem selectedItem = (MenuItem) actionEvent.getSource();
        String school = selectedItem.getText();
        rosterTextArea.appendText(listPrint(roster, school));
    }

    /**
     * Helper method for onSchoolSelected
     * @param roster The Student Roster
     * @param school School
     * @return List of students from particular school
     */
    private String listPrint(Roster roster, String school) {
        Roster newRoster = new Roster();
        StringBuilder stringBuilder = new StringBuilder();

        for (int i = 0; i < roster.getSize(); i++) {
            if (roster.getRoster()[i].getMajor().getSchool().equalsIgnoreCase
                    (school)) {
                newRoster.add(roster.getRoster()[i]);
            }
        }
        if (newRoster.getRoster()[0] == null) {
            stringBuilder.append("Student roster is empty!\n");
            return stringBuilder.toString();
        }
        stringBuilder.append("* Students in " + school + " *\n");
        Student temp;
        for (int i = 0; i < newRoster.getSize(); i++) {
            for (int j = i + 1; j < newRoster.getSize(); j++) {
                if (newRoster.getRoster()[i].compareTo(
                        newRoster.getRoster()[j]) > 0) {
                    temp = newRoster.getRoster()[i];
                    newRoster.getRoster()[i] = newRoster.getRoster()[j];
                    newRoster.getRoster()[j] = temp;
                }
            }
        }
        for (int i = 0; i < newRoster.getSize(); i++) {
            stringBuilder.append(newRoster.getRoster()[i].toString() + "\n");
        }
        stringBuilder.append("* end of list **\n");
        return stringBuilder.toString();
    }

    /**
     * Handles print by enrollment button click.
     * @param actionEvent
     */
    @FXML
    protected void onPrintEnrollmentClick(ActionEvent actionEvent) {
        rosterTextArea.appendText(enrollment.print());
    }

    /**
     * Helper method for printTuition(). Checks for anything empty.
     * @param enrollment Student enrollment.
     * @param roster Student roster.
     */
    private boolean printTuitionEmptyChecker(Enrollment enrollment, Roster
            roster){
        if(enrollment.getSize() == 0){
            rosterTextArea.appendText("Enrollment is empty!\n");
            return false;
        }
        rosterTextArea.appendText("** Tuition due **\n");
        return true;
    }

    /**
     * Print Tuition Method
     * @return Returns tuition due
     */
    private String printTuition(){
        StringBuilder stringBuilder = new StringBuilder();
        if(printTuitionEmptyChecker(enrollment, roster)) {
            stringBuilder.append("* Tuition Due *\n");
            for (int i = 0; i < enrollment.getSize(); i++) {
                Profile profile = enrollment.getEnrollStudents()[i].getProfile();
                Student student = roster.getRoster()[roster.find(new Resident(
                        profile, null, 0, 0))];
                stringBuilder.append(profile.toString() + " (");
                if (student.isResident()) { stringBuilder.append("Resident) enrolled  ");
                } else {
                    NonResident nonResident = (NonResident) student;
                    if (nonResident.isInternational()) {
                        International internation = (International) nonResident;
                        if (internation.getisStudyAbroad()) {
                            stringBuilder.append("International studentstudy " +
                                    "abroad) enrolled ");
                        } else {
                            stringBuilder.append("International student) enrolled");
                        }
                    } else {
                        if (nonResident.isTriState()) {
                            TriState triState = (TriState) nonResident;
                            stringBuilder.append("Tri-state " +
                                    triState.getState() + ") enrolled ");
                        } else {
                            stringBuilder.append("Non-Resident) enrolled ");
                        }
                    }
                }
                EnrollStudent enrolled = enrollment.getEnrollStudents()[
                        enrollment.find(new EnrollStudent(profile, 0))];
                DecimalFormat formatter = new DecimalFormat("#,###.00");
                stringBuilder.append(enrolled.getCreditsEnrolled() +
                        " credits: tuition due: $" + formatter.format(
                        student.tuitionDue(enrolled.getCreditsEnrolled()))+ "\n");
            }
            stringBuilder.append("* end of tuition due *\n");
        }
        return stringBuilder.toString();
    }

    /**
     * Handles print by tuition due button click.
     * @param actionEvent
     */
    @FXML
    protected void onPrintTuitionClick(ActionEvent actionEvent) {
        rosterTextArea.appendText(printTuition());
    }

    /**
     * Handles semester end button click.
     * @param actionEvent
     */
    @FXML
    protected void onPrintSemesterEnd(ActionEvent actionEvent) {
        StringBuilder stringBuilder = new StringBuilder();
        stringBuilder.append("Credit completed has been updated.\n");
        stringBuilder.append("** list of students eligible for graduation **\n");
        for(Student student : roster.getStudents()){
            int creditsCompleted = student.getCreditCompleted();
            int creditsEnrolled = enrollment.getCreditsEnrolled(student);
            student.setCreditCompleted(creditsCompleted + creditsEnrolled);
            if(student.getCreditCompleted() >= 120){
                stringBuilder.append(student.toString() + "\n");
            }
        }
        rosterTextArea.appendText(stringBuilder.toString());
        printSemesterEnd.setDisable(true);
        printSemesterEnd.setDisable(true);
    }
}