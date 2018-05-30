/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ferramentas;

import java.io.File;
import java.util.Arrays;
import javafx.scene.input.Clipboard;
import javafx.scene.input.ClipboardContent;
import javafx.stage.FileChooser;
import javafx.stage.Window;

/**
 *
 * @author IE
 */
public abstract class Gerais {
    public static void copiar(String texto){
        final Clipboard clipboard = Clipboard.getSystemClipboard();
        final ClipboardContent content = new ClipboardContent();
        content.putString(texto);
        clipboard.setContent(content);
    }
    
    public static File abrirArquivo(Window ownerWindow){
        FileChooser chooser = new FileChooser();
        chooser.setSelectedExtensionFilter(new FileChooser.ExtensionFilter("imagem", Arrays.asList(".jpg",".jpeg",".png",".gif")));
        return chooser.showOpenDialog(ownerWindow);
    }
}
