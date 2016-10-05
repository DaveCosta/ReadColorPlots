/**
 * Created by david on 07/10/15.
 */

package edu.mephys.tools;

import edu.mephys.tools.RCPlotsLib.RCImage;
import edu.mephys.tools.RCPlotsLib.RCPlotsController;
import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Scene;
import javafx.scene.canvas.Canvas;
import javafx.scene.canvas.GraphicsContext;
import javafx.scene.image.Image;
import javafx.scene.image.PixelReader;
import javafx.scene.image.PixelWriter;
import javafx.scene.layout.GridPane;
import javafx.scene.paint.Color;
import javafx.scene.shape.Rectangle;
import javafx.scene.text.Text;
import javafx.stage.Stage;

import static edu.mephys.tools.RCPlotsLib.RCTools.distance;

public class RCPlots extends Application  {

    Text  info;
    PixelReader pxreader;

     @Override
    public void start(Stage primaryStage) throws Exception {

        int h, v;
        GraphicsContext gc;

        FXMLLoader loader = new FXMLLoader();
         ClassLoader classLoader = getClass().getClassLoader();
        loader.setLocation(classLoader.getResource("rcplots.fxml"));
        GridPane root = (GridPane)loader.load();
        RCPlotsController controller =(RCPlotsController)loader.getController();
        Scene scene = new Scene(root, 1070, 800);
        primaryStage.setTitle("ReadColorPlots");
        primaryStage.getIcons().add(new Image(classLoader.getResourceAsStream("icons/RCPlots.png")));
     
        scene.getStylesheets().add("rcplots.css");
        primaryStage.setScene(scene);
        primaryStage.show();

        //objects
        RCImage img = new RCImage("images/image.jpg");
        pxreader = img.getPixelReader();
        controller.setImage(img);
        h = img.x_max;
        v = img.y_max;

        controller.point.setText("x=" + img.rlx + " y1=" + img.y1 + " y2=" + img.y2);
        info=controller.info;
        controller.dimlabel.setText("" + h + " x " + v);
        final Rectangle rec=controller.rec;
        final Canvas canvas=controller.canvas;
        canvas.setHeight(v);
        canvas.setWidth(h);


         controller.canvas.setScaleX(h/((double)(img.x2-img.x1+1)));
         controller.canvas.setScaleY(h/((double)(img.x2-img.x1+1)));

        controller.column.setHeight(img.y2 - img.y1 + 1);
        controller.column.setWidth(img.rl);
        PixelWriter cwpx = controller.column.getGraphicsContext2D().getPixelWriter();
        for (int i = img.y1; i < img.y2; i++) {
            Color c = pxreader.getColor(img.rlx, i);
            for (int j = 0; j < img.rl; j++) {
                cwpx.setColor(j,i - img.y1, c);
            }
        }

        gc= canvas.getGraphicsContext2D();
      //  gc.setFill(Color.LIGHTGRAY);
       // gc.fillRect(0, 0, h, v);

        PixelWriter pw = gc.getPixelWriter();
        for (int i = img.x1; i < img.x2; i++)
            for (int j = img.y1; j < img.y2; j++) {
                Color c = img.getColor(i, j);
                if (distance(c, Color.WHITE) < 0.10) pw.setColor(i, j, Color.WHITE);
                if (distance(c, Color.BLACK) < 0.10) pw.setColor(i, j, Color.BLACK);
                else pw.setColor(i, j, c);
            }


//        Color [] arrayC=new Color[vv];
//        for(int i = v1; i <= v2; i++){
//            Color c=pxreader.getColor(rlx, i);
//            arrayC[i]=new Color((float)c.getRed(),(float)c.getGreen(),(float)c.getBlue());
//        }

    }

    public static void main(String[] args) {
        launch(args);
    }


}
