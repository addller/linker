package view.entrar;

import acesso.Login;
import ambiente.Ambiente;
import cadastro.Cadastro;
import dao.BaseDados;
import dao.DAORead;
import dao.TypeBaseDados;
import ferramentas.Formatos;
import java.net.URL;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ResourceBundle;
import java.util.logging.Level;
import java.util.logging.Logger;
import javafx.application.Platform;
import javafx.beans.value.ObservableValue;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.Button;
import javafx.scene.control.PasswordField;
import javafx.scene.control.TextField;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.layout.Pane;
import javafx.stage.Stage;
import perfil.Membro;
import perfil.StatusMembro;
import view.Cenario;
import view.MyView;
import view.main.ViewMain;

public class ViewEntrar extends MyView implements Initializable {

    @FXML
    private TextField txtPesquisar,
            txtLogin;
    @FXML
    private PasswordField txtSenha;

    @FXML
    private ImageView imgFundo,
            imgLupaPesquisa,
            imgCadastro;
    @FXML
    private Button btnCadastrar,
            btnEntrar,
            btnVoltar,
            btnHome;

    public ViewEntrar(Ambiente ambienteExecucao, MyView viewPrevious) {
        super(new Cenario("Ekemera  - Linker", "viewEntrar"), ambienteExecucao);
        this.viewPrevious = viewPrevious;
        estilizar();
    }

    @Override
    public void initialize(URL url, ResourceBundle rb) {
        getCenario().setSair(true);
        getCenario().setResisable(true);
        arredondarImages();
        eventos();

    }

    private void arredondarImages() {
        Formatos.arredondarImageView(imgCadastro, 1, 0, 52, 52);

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
            setSizeStage(900, 540);
        });
    }

    @Override
    protected void eventos() {
        Platform.runLater(() -> {
            btnCadastrar.setOnAction(onAction -> showViewCadastrar());
            btnHome.setOnAction(on -> showViewHome());
            btnEntrar.setOnAction(on -> logar());
            txtSenha.textProperty().bind(txtLogin.textProperty());
            voltar(btnVoltar);
        });
    }

    private void logar() {
        try {
            DAORead reader = new DAORead(null, BaseDados.getConnection(TypeBaseDados.LINKER));
            ResultSet result = reader.logar(txtLogin.getText(), txtSenha.getText().getBytes());
            Login login = new Login(result);
            Cadastro cadastro = new Cadastro(result);
            Membro membro = new Membro(login, StatusMembro.MEMBRO);
            membro.setId(result.getLong("id"));
            membro.setCadastro(cadastro);
            ViewMain home = (ViewMain) viewMain;            
            Platform.runLater(() -> {                
                home.setMembro(membro);
                home.show();
            });
        } catch (SQLException ex) {
            Logger.getLogger(ViewEntrar.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    

}
