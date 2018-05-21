/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package perfil;

import cadastro.Cadastro;
import acesso.Login;
import denuncia.Denuncia;
import java.util.HashSet;
import publicacao.Comentario;
import publicacao.Notificacao;
import publicacao.Postagem;

/**
 *
 * @author IE
 */
public class Membro {

    private long id;
    private Login login;
    private StatatusMembro status;
    private boolean isSuspenso,
            isBanido;

    public Membro(Login login, StatatusMembro status) {
        this.login = login;
        this.status = status;
    }

    public void editarPerfil(Cadastro cadastro) {
    }

    public void denunciarPostagem(Postagem postagem, Denuncia denuncia) {
    }

    void comentarPostagem(Postagem postagem, Comentario comentario) {
    }

    public void avaliarPostagem(Postagem postagem) {
    }

    public void excluirConta() {
    }

    public void publicarPostagem(Postagem postagem) {
    }

    public void inscreverseNoPerfilDe(Membro membro) {
    }

    public HashSet<Notificacao> getNotificacoes() {
        throw new IllegalArgumentException("");
    }
}
