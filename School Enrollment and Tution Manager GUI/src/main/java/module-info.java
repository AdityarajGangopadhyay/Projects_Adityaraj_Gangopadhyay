module mainpackage.project3 {
    requires javafx.controls;
    requires javafx.fxml;


    opens mainpackage.project3 to javafx.fxml;
    exports mainpackage.project3;
}