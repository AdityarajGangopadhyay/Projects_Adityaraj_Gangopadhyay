package mainpackage.project3;

import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Scene;
import javafx.stage.Stage;

import java.io.IOException;

/**
 * Runner for the Whole Project. Used to launch the GUI.
 * @author Adityaraj Gangopadhyay
 * @author Kirtan Patel
 */
public class TuitionManagerMain extends Application {

    /**
     * Sets the stage, scene, and title for out Tuition Manager Project.
     * @param stage
     * @throws IOException
     */
    @Override
    public void start(Stage stage) throws IOException {
        FXMLLoader fxmlLoader = new FXMLLoader(TuitionManagerMain.class.getResource("TuitionManagerView.fxml"));
        Scene scene = new Scene(fxmlLoader.load(), 500, 600);
        stage.setTitle("Project 3 - Tuition Manager");
        stage.setScene(scene);
        stage.show();
    }

    /**
     * Main method which will start the GUI.
     * @param args
     */
    public static void main(String[] args) {
        launch();
    }
}