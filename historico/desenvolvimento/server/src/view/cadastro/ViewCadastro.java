package view.cadastro;

import acesso.Login;
import ambiente.Ambiente;
import cadastro.Cadastro;
import dao.BaseDados;
import dao.DAOCreate;
import dao.TypeBaseDados;
import ferramentas.Formatos;
import ferramentas.Mensagem;
import ferramentas.Validacao;
import java.net.URL;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ResourceBundle;
import java.util.logging.Level;
import java.util.logging.Logger;
import javafx.application.Platform;
import javafx.beans.value.ObservableValue;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.Button;
import javafx.scene.control.CheckBox;
import javafx.scene.control.DatePicker;
import javafx.scene.control.PasswordField;
import javafx.scene.control.TextField;
import javafx.scene.image.ImageView;
import javafx.scene.layout.HBox;
import javafx.scene.layout.Pane;
import javafx.stage.Stage;
import perfil.Membro;
import perfil.StatusMembro;
import view.Cenario;
import view.MyView;

public class ViewCadastro extends MyView implements Initializable {

    @FXML
    private TextField txtPesquisar,
            txtNome,
            txtEmail,
            txtLogin;
    @FXML
    private PasswordField txtSenha,
            txtConfirmarSenha;
    @FXML
    private CheckBox checkM,
            checkF;

    @FXML
    private DatePicker datePickerNascimento;

    @FXML
    private HBox hboxTopo;
    @FXML
    private ImageView imgFundo,
            imgLupaPesquisa,
            imgCadastro;
    @FXML
    private Button btnCadastrar,
            btnEntrar,
            btnVoltar,
            btnHome;

    public ViewCadastro(Ambiente ambienteExecucao, MyView viewPrevious) {
        super(new Cenario("Ekemera  - Linker", "viewCadastro"), ambienteExecucao);
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
            txtEmail.textProperty().bind(txtNome.textProperty());
            txtLogin.textProperty().bind(txtNome.textProperty());
            btnCadastrar.setOnAction(onAction -> cadastrarMembro());
            toogleCheckBox(checkF, checkM);
            btnEntrar.setOnAction(on -> showViewEntrar());
            btnHome.setOnAction(on -> showViewHome());
            voltar(btnVoltar);            
        });

    }

    private void cadastrarMembro() {

        Validacao preValidacao = Validacao.validar(
                new Validacao(txtSenha.getText().equals(txtConfirmarSenha.getText()), "As senhas informadas não conferem"),
                new Validacao(checkF.isSelected() || checkM.isSelected(), "É necessário informar o sexo"),
                new Validacao(datePickerNascimento.getValue() != null, "É necessário informar a data de nascimento")
        );

        if (!preValidacao.isValida()) {
            Mensagem.alerta(preValidacao.getMensagem());
            return;
        }

        Login login = new Login(txtEmail.getText(), txtLogin.getText(), txtSenha.getText().getBytes());
        char sexo = checkF.isSelected() ? 'F' : 'M';
        Cadastro cadastro = new Cadastro(txtNome.getText(), datePickerNascimento.getValue(), sexo);
        Membro membro = new Membro(login, StatusMembro.MEMBRO);
        membro.setCadastro(cadastro);
        preValidacao = Validacao.validar(login.validar(), cadastro.validar());

        if (!preValidacao.isValida()) {
            Mensagem.alerta(preValidacao.getMensagem());
            return;
        }
        try {
            DAOCreate registro = new DAOCreate(null, BaseDados.getConnection(TypeBaseDados.LINKER));
            ResultSet result = registro.registrarMembro(membro);
            Mensagem.alerta("Cadastrado: " + result.getLong("id"));
        } catch (SQLException ex) {
            Logger.getLogger(ViewCadastro.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

}
