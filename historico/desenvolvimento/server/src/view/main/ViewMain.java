package view.main;

import acesso.Login;
import ambiente.Ambiente;
import cadastro.Cadastro;
import java.lang.reflect.Member;
import java.net.URL;
import java.util.Arrays;
import java.util.ResourceBundle;
import javafx.application.Platform;
import javafx.beans.property.BooleanProperty;
import javafx.beans.property.SimpleBooleanProperty;
import javafx.beans.value.ObservableValue;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.control.TextField;
import javafx.scene.image.ImageView;
import javafx.scene.layout.HBox;
import javafx.scene.layout.Pane;
import javafx.scene.layout.VBox;
import javafx.stage.Stage;
import perfil.Membro;
import view.Cenario;
import view.MyView;

public class ViewMain extends MyView implements Initializable {

    @FXML
    private TextField txtPesquisar;
    @FXML
    private HBox hboxTopo;
    @FXML
    private VBox vboxDadosMembro;
    @FXML
    private ImageView imgFundo,
            imgLupaPesquisa,
            imgMembro;
    @FXML
    private Button btnCadastrar,
            btnEntrar;

    private Membro membro;
    private BooleanProperty membroLogado = new SimpleBooleanProperty(false);

    public ViewMain(Ambiente ambienteExecucao) {
        super(new Cenario("Ekemera  - Linker", "viewMain"), ambienteExecucao);
        MyView.viewMain = ViewMain.this;
    }

    @Override
    public void initialize(URL url, ResourceBundle rb) {
        getCenario().setSair(true);
        getCenario().setResisable(true);
        estilizar();
        eventos();
    }

    private void estilizar() {
        Platform.runLater(() -> {
            Stage palco = getStage();
            imgFundo.setPreserveRatio(false);
            palco.widthProperty().addListener((ObservableValue<? extends Number> observable, Number oldValue, Number newValue) -> {
                imgFundo.setFitWidth((double) newValue);
                txtPesquisar.setPrefWidth((double) newValue * .5);
                imgLupaPesquisa.setLayoutX(txtPesquisar.getWidth() + txtPesquisar.getLayoutX() - 30);
                ((Pane) txtPesquisar.getParent()).setPrefWidth(txtPesquisar.getWidth());

            });
            palco.heightProperty().addListener((ObservableValue<? extends Number> observable, Number oldValue, Number newValue) -> {
                imgFundo.setFitHeight((double) newValue);
            });
            setSizeStage(850, 510);
        });
    }

    @Override
    protected void eventos() {
        Platform.runLater(() -> {
            btnCadastrar.setOnAction(on -> showViewCadastrar());
            btnEntrar.setOnAction(on -> showViewEntrar());
            btnCadastrar.visibleProperty().bind(membroLogado.not());
            btnEntrar.visibleProperty().bind(membroLogado.not());
            vboxDadosMembro.visibleProperty().bind(membroLogado);
        });
    }

    public final void setMembro(Membro membro) {
        vboxDadosMembro.getChildren().clear();
        membroLogado.setValue(membro != null);
        if (!membroLogado.get()) {
            return;
        }

        this.membro = membro;
        Cadastro cadastro = membro.getCadastro();
        Login login = membro.getLogin();
        String[][] dados = {
            {"Nome", cadastro.getNome()},
            {"Nascimento", cadastro.getNascimento().toLocalDate().toString()},
            {"Sexo", cadastro.getSexo() + ""},
            {"Login name", login.getLoginName()},
            {"Email", login.getEmail()},
            {"Senha", Arrays.toString(login.getPass())},
            {"Id", login.getId() + ""}
        };
        for (String[] dado : dados) {
            vboxDadosMembro.getChildren().add(new HBox(new Label(dado[1], new Label(dado[0]))));
            System.out.println(dado[0]+" - "+dado[1]);
        }
    }

}
