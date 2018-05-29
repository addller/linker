package ambiente;

import javafx.application.Application;
import javafx.stage.Stage;
import view.Cenario;
import view.MyView;
import view.main.ViewMain;

public class Ambiente extends Application {

    private Stage palco;

    @Override
    public void start(Stage primaryStage) {
        ViewMain mainController = new ViewMain(this);
        palco = primaryStage;
        mainController.show();
    }

    public void atualizarScene(MyView myView) {
        Cenario cenario = myView.getCenario();
        atualizarFechamento(cenario);
        palco.setScene(cenario.getCena());
        palco.setTitle(cenario.getTitulo());
        palco.setResizable(cenario.isResisable());
        palco.show();
    }

    private void atualizarFechamento(Cenario cenario) {
        palco.setOnCloseRequest((event) -> {
            if (!cenario.sair()) {
                event.consume();
                return;
            }
            //Serializar.gravar();
        });
    }

    public Stage getStage() {
        return palco;
    }

    public static void main(String[] args) {
        launch(args);
    }

}
