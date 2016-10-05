package edu.mephys.tools.RCPlotsLib;

import javafx.scene.image.Image;
import javafx.scene.image.PixelReader;
import javafx.scene.paint.Color;

import static edu.mephys.tools.RCPlotsLib.RCTools.distance;


/**
 * Created by david on 14/10/15.
 */
public class RCImage {

    private Image image;
    private PixelReader pxreader;

    public final int rlx,rl,x1, y1, x2, y2, x_max, y_max, x_med, y_med;

    public RCImage(String filename) {

        int _x1,_x2,_y1,_y2,cx2,cx1;
        boolean flag;

        image = new Image(filename /*getClass().getResourceAsStream(filename)*/);
        pxreader=image.getPixelReader();

        x_max = (int) image.getWidth();
        y_max = (int) image.getHeight();

        x_med=x_max/2;
        y_med=y_max/2;

        _x1 = 0;
        _y1 = 0;
        _x2 = x_max-1;
        _y2 = y_max-1;

        do {
            while(isWhite(_x1,y_med)) ++_x1;

            flag = false;
            for (int j = y_med-10; j <=y_med+10 ; j++)
                if(isWhite(_x1,j)){
                    flag=true;
                    ++_x1;
                    break;
                }
        } while(flag);


        do {
            while(isWhite(_x2,y_med)) --_x2;

            flag = false;
            for (int j = y_med-10; j <=y_med+10 ; j++)
                if(isWhite(_x2,j)){
                    flag=true;
                    --_x2;
                    break;
                }
        } while(flag);


        do {
            while(isWhite(x_med,_y1)) ++_y1;

            flag = false;
            for (int i = x_med-10; i <=x_med+10 ; i++)
                if(isWhite(i,_y1)){
                    flag=true;
                    ++_y1;
                    break;
                }
        } while(flag);


        do {
            while(isWhite(x_med,_y2)) --_y2;

            flag = false;
            for (int i = x_med-10; i <=x_med+10 ; i++)
                if(isWhite(i,_y2)){
                    flag=true;
                    --_y2;
                    break;
                }
        } while(flag);

        cx2=_x2;
        while (!isWhite(_x2, x_med)) --_x2;
        cx1=_x2;
        rlx=(cx2+cx1) /2;
        rl=cx2-cx1+1;

        do {
            while(isWhite(_x2,y_med)) --_x2;

            flag = false;
            for (int j = y_med-10; j <=y_med+10 ; j++)
                if(isWhite(_x2,j)){
                    flag=true;
                    --_x2;
                    break;
                }
        } while(flag);

        x1 = _x1;
        y1 = _y1;
        x2 = _x2;
        y2 = _y2;
    }

    public PixelReader getPixelReader(){
        return image.getPixelReader();
    }

    public Image getImage(){
        return this.image;
    }

    public Color getColor(int i, int j) {
        if ((i < x1)||(i >= x2)||(j < y1)||(j >= y2))  return null;
        return pxreader.getColor(i,j);
    }

     public boolean isWhite(int i,int j){
        return distance(pxreader.getColor(i, j), Color.WHITE) < 0.2;
    }


}
