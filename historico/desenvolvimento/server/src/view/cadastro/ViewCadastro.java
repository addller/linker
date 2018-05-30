package view.cadastro;

import acesso.Login;
import ambiente.Ambiente;
import cadastro.Cadastro;
import dao.BaseDados;
import dao.DAOCreate;
import dao.TypeBaseDados;
import ferramentas.EscalaImagem;
import ferramentas.Formatos;
import ferramentas.Gerais;
import ferramentas.Mensagem;
import ferramentas.Validacao;
import java.awt.Graphics2D;
import java.awt.Image;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.net.URL;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ResourceBundle;
import java.util.logging.Level;
import java.util.logging.Logger;
import javafx.application.Platform;
import javafx.beans.value.ObservableValue;
import javafx.embed.swing.SwingFXUtils;
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
import javax.imageio.ImageIO;
import perfil.Membro;
import perfil.StatusMembro;
import view.Cenario;
import view.MyView;
import view.main.ViewMain;

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
    private boolean changeImage;

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
            imgCadastro.setOnMouseReleased(on -> selecionarImagemPerfil());
        });

    }

    private void selecionarImagemPerfil() {
        File arquivoImagem = Gerais.abrirArquivo(getCenario().getCena().getWindow());
        try {
            if (arquivoImagem == null) {
                return;
            }
            changeImage = true;
            BufferedImage img = ImageIO.read(arquivoImagem);
            this.imgCadastro.setImage(SwingFXUtils.toFXImage(img, null));
        } catch (IOException ex) {
            Logger.getLogger(ViewCadastro.class.getName()).log(Level.SEVERE, null, ex);
        }

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
            membro.setId(result.getLong("id"));
            registrarImagemPerfil(membro, registro);
            ViewMain home = (ViewMain) viewMain;
            home.setMembro(membro);
            home.show();
        } catch (SQLException | IOException ex) {
            Logger.getLogger(ViewCadastro.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    private void registrarImagemPerfil(Membro membro, DAOCreate registro) throws SQLException, IOException {
        if (changeImage) {
            int largura = (int) imgCadastro.getFitWidth(),
                    altura = (int) imgCadastro.getFitHeight();
            membro.setImgMembro(SwingFXUtils.fromFXImage(imgCadastro.getImage(), new BufferedImage(largura, altura, BufferedImage.TYPE_INT_RGB)));
            for (EscalaImagem escala : EscalaImagem.values()) {
                registro.registrarImagemPerfil(membro, escala);
            }
        }
    }
    
    
}
