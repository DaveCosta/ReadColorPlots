package edu.mephys.tools.RCPlotsLib;

import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.canvas.Canvas;
import javafx.scene.canvas.GraphicsContext;
import javafx.scene.control.Label;
import javafx.scene.image.Image;
import javafx.scene.image.PixelReader;
import javafx.scene.input.MouseButton;
import javafx.scene.input.MouseEvent;
import javafx.scene.paint.Color;
import javafx.scene.shape.Rectangle;
import javafx.scene.text.Text;

import java.net.URL;
import java.util.ResourceBundle;

import static edu.mephys.tools.RCPlotsLib.RCTools.distance;

/**
 * Created by david on 15/10/15.
 */
public class RCPlotsController implements Initializable {
    static int numClick = 0;
    public int h, v, rlx, x_med, y_med;
    public Text point, info;
    public Canvas canvas, column, iv;
    public Rectangle rec;
    public Label dimlabel;
    boolean showLines = false;
    GraphicsContext gc = null;
    Image image = null;
    private PixelReader pxreader = null;


    public void initialize(URL location, ResourceBundle resources) {

    }

    public void setImage(RCImage img) {
        h = img.x_max;
        v = img.y_max;
        rlx = img.rlx;
        x_med = img.x_med;
        y_med = img.y_med;
        pxreader = img.getPixelReader();
        gc = iv.getGraphicsContext2D();
        image = img.getImage();
        iv.setHeight(v);
        iv.setWidth(h);
        gc.drawImage(image, 0, 0);
    }

    @FXML
    protected void handleClickEvent(MouseEvent event) {
        if (event.getButton().equals(MouseButton.PRIMARY)) {
            if (event.getClickCount() == 2) {
                showLines = !showLines;
                if (showLines) {
                    gc.drawImage(image, 0, 0);
                    gc.moveTo(rlx, 0.0);
                    gc.lineTo(rlx, v);
                    gc.setStroke(Color.INDIGO);
                    gc.stroke();
                    gc.beginPath();
                    gc.moveTo(0.0, y_med);
                    gc.lineTo(h, y_med);
                    gc.setStroke(Color.CADETBLUE);
                    gc.stroke();
                    gc.beginPath();
                    gc.moveTo(x_med, 0.0);
                    gc.lineTo(x_med, v);
                    gc.setStroke(Color.CADETBLUE);
                    gc.stroke();
                } else {
                    gc.drawImage(image, 0, 0);
                }

            } else {
                int x, y;
                x = (int) event.getX();
                y = (int) event.getY();

                Color c = pxreader.getColor(x, y);

                point.setText("" + x + " x " + y + " " + String.format("\nRGB(%.3f,%.3f,%.3f)", c.getRed(), c.getGreen(), c.getBlue()) +
                        String.format("\nblack distance = %.3f", distance(c, Color.BLACK)) + String.format(" white distance = %.3f", distance(c, Color.WHITE)));

                rec.setFill(c);
                event.consume();
                numClick++;
            }
        }

        if (event.getButton().equals(MouseButton.SECONDARY)) {
            point.setText("Noddy");
        }

    }

}
