/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ferramentas;

import javafx.scene.SnapshotParameters;
import javafx.scene.effect.DropShadow;
import javafx.scene.image.ImageView;
import javafx.scene.image.WritableImage;
import javafx.scene.paint.Color;
import javafx.scene.shape.Rectangle;

/**
 *
 * @author IE
 */
public abstract class Formatos {

    public static void arredondarImageView(ImageView imageView, double x, double y, double width, double height) {
        Rectangle moldura = new Rectangle(x, y, width, height);
        moldura.setArcWidth(width);
        moldura.setArcHeight(height);
        imageView.setClip(moldura);
        SnapshotParameters parameters = new SnapshotParameters();
        parameters.setFill(Color.TRANSPARENT);
        WritableImage image = imageView.snapshot(parameters, null);
        imageView.setClip(null);
        imageView.setImage(image);
    }
}
