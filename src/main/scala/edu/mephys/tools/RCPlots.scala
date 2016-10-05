import javafx.application.Application
import javafx.fxml.FXMLLoader
import javafx.scene.Scene
import javafx.scene.layout.StackPane
import javafx.stage.Stage
import javafx.scene.control.Label

class Test extends Application {
  println("Test()")

  override def start(primaryStage: Stage) {
    val loader: FXMLLoader = new FXMLLoader
    loader.setLocation(getClass.getResource("rcplots.fxml"))

    primaryStage.setTitle("Sup!")

    val root = new StackPane
    root.getChildren.add(new Label("Hello world!"))

    primaryStage.setScene(new Scene(root, 300, 300))
    primaryStage.show()
  }
}

object Test {
  def main(args: Array[String]) {
    Application.launch(classOf[Test], args: _*)
  }
}