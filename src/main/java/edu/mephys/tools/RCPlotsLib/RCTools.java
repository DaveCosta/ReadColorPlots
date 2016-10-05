package edu.mephys.tools.RCPlotsLib;

import javafx.scene.paint.Color;

/**
 * Created by david on 14/10/15.
 */
public abstract class RCTools {

    public static double distance(Color c1, Color c2) {
        double d1, d2, d3, r, g, b;
        r = Math.abs(c1.getRed() - c2.getRed());
        g = Math.abs(c1.getGreen() - c2.getGreen());
        b = Math.abs(c1.getBlue() - c2.getBlue());

        d1 = Math.sqrt((r * r + g * g + b * b) / 3.0);

        d2 = Math.max(Math.max(r, g), b);

        if (Math.abs(d1 - d2) < 0.01) {

            if (c1.getRed() < 0.3) c1 = Color.BLACK;
            else if (c1.getRed() > 0.7) c1 = Color.WHITE;
        }

        r = Math.abs(c1.getRed() - c2.getRed());
        g = Math.abs(c1.getGreen() - c2.getGreen());
        b = Math.abs(c1.getBlue() - c2.getBlue());

        d2 = Math.max(Math.max(r, g), b);

        return d2;
    }
}
