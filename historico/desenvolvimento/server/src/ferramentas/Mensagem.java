package ferramentas;

import java.io.File;
import javafx.scene.control.Alert;
import javafx.stage.FileChooser;
import javafx.stage.Window;

public abstract class Mensagem {

    public static void alerta(Alert.AlertType tipoAlerta, String mensagem) {
        Alert alerta = new Alert(tipoAlerta);
        alerta.setTitle("Informação");
        alerta.setHeaderText(mensagem);
        alerta.showAndWait();
    }
    public static void alerta(String mensagem) {
        alerta(Alert.AlertType.INFORMATION, mensagem);
    }

    public static File abrirArquivo(Window window) {
        FileChooser chooser = new FileChooser();
        return chooser.showOpenDialog(window);
    }

}
