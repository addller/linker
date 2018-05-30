package view;

import ambiente.Ambiente;
import javafx.beans.value.ObservableValue;
import javafx.scene.control.CheckBox;
import javafx.scene.control.Control;
import javafx.scene.control.Label;
import javafx.scene.control.TextField;
import javafx.scene.image.Image;
import javafx.stage.Stage;
import javafx.stage.Window;
import view.cadastro.ViewCadastro;
import view.entrar.ViewEntrar;

public abstract class MyView {

    private final Cenario cenario;
    private final Ambiente ambienteExecucao;
    protected Window ownerWindow;
    protected MyView viewPrevious;
    protected static MyView viewMain;
    protected Image igmPerfil;

    public MyView(Cenario cenario, Ambiente ambienteExecucao) {
        this.cenario = cenario;
        this.cenario.carregarFXML(MyView.this);
        this.ambienteExecucao = ambienteExecucao;
    }

    public Cenario getCenario() {
        return cenario;
    }

    public Ambiente getAmbienteExecucao() {
        return ambienteExecucao;
    }

    public void show() {
        ambienteExecucao.atualizarScene(this);
    }

    protected void voltar(Control controlVoltar) {
        controlVoltar.setOnMouseReleased(onRelease -> viewPrevious.show());
    }

    protected void addTextValue(Label[] labels, String[] values) {
        for (int i = 0; i < labels.length; i++) {
            labels[i].textProperty().setValue(values[i]);
        }
    }

    public int toInt(TextField value) {
        return (int) Double.parseDouble(value.getText());
    }

    public void setSizeStage(double width, double height) {
        Stage palco = getStage();
        palco.setMaxWidth(width);
        palco.setMaxHeight(height);
    }

    public void bindWidth(Control parent, Control children) {
        children.prefWidthProperty().bind(parent.widthProperty());
    }

    public void bindHeight(Control parent, Control children) {
        children.prefHeightProperty().bind(parent.prefHeightProperty());
    }

    public void bindWidthHeight(Control parent, Control children) {
        bindWidth(parent, children);
        bindHeight(parent, children);
    }

    public Stage getStage() {
        return ambienteExecucao.getStage();
    }

    public final void toogleCheckBox(CheckBox... checks) {
        for (CheckBox check : checks) {
            check.selectedProperty().addListener((ObservableValue<? extends Boolean> observable, Boolean oldValue, Boolean newValue) -> {
                if (newValue) {
                    for (CheckBox outroCheck : checks) {
                        if (outroCheck != check && outroCheck.isSelected()) {
                            outroCheck.setSelected(false);
                        }
                    }
                }
            });
        }
    }

    public void setViewPrevious(MyView viewPrevious) {
        this.viewPrevious = viewPrevious;
    }
    
    public void showViewHome(){
        viewMain.show();
    }

    public void showViewEntrar() {
        ViewEntrar viewEntrar = new ViewEntrar(ambienteExecucao, this);
        viewEntrar.show();
    }

    public void showViewCadastrar() {
        ViewCadastro viewCadastro = new ViewCadastro(ambienteExecucao, this);
        viewCadastro.show();
    }

    protected abstract void eventos();

}
