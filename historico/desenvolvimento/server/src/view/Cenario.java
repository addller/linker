package view;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javafx.fxml.FXMLLoader;
import javafx.scene.Scene;
import javafx.scene.layout.AnchorPane;

public class Cenario extends AnchorPane {

    private String titulo;
    private final String urlFXML;
    private Scene cena;
    private boolean sair, resisable;

    public Cenario(String titulo, String urlFXML) {
        this.titulo = titulo;
        this.urlFXML = urlFXML.endsWith(".fxml")? urlFXML: urlFXML+".fxml";
    }

    public Scene getCena() {
        return cena;
    }
    /**este método é responsável encerrar a aplicação
     * @return true ou false
     * @see ambiente.Ambiente#atualizarFechamento
     */
    public boolean sair() {
        return sair;
    }

    public void setSair(boolean sair) {
        this.sair = sair;
    }

    public String getTitulo() {
        return titulo;
    }

    public void setTitulo(String titulo) {
        this.titulo = titulo;
    }

    protected final void carregarFXML(MyView controller) {
        try {
            FXMLLoader loader = new FXMLLoader(controller.getClass().getResource(urlFXML));
            loader.setController(controller);
            loader.setRoot(this);
            this.cena = new Scene(loader.load());
        } catch (IOException ex) {
            Logger.getLogger(Cenario.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public boolean isResisable() {
        return resisable;
    }

    public void setResisable(boolean resisable) {
        this.resisable = resisable;
    }

}
