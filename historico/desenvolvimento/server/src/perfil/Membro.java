/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package perfil;

import cadastro.Cadastro;
import acesso.Login;
import denuncia.Denuncia;
import java.awt.Image;
import java.awt.image.BufferedImage;
import java.util.HashSet;
import publicacao.Comentario;
import publicacao.Notificacao;
import publicacao.Postagem;
import java.util.Observable;


/**
 *
 * @author IE
 */
public class Membro extends Observable{

   private long id;
   private final Login login;
   private final StatusMembro statusMembro;
   private boolean suspenso;
   private boolean banido;
   private final HashSet<Notificacao> notificacoes;
   private final HashSet<Incrito> inscritos;
   private long totalInscritos;
   private Cadastro cadastro;
   private BufferedImage imgMembro;

    public Membro(Login login, StatusMembro status) {
        this.login = login;
        this.statusMembro = status;
        this.notificacoes = new HashSet<>();
        this.inscritos = new HashSet<>();
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
        return notificacoes;
    }

    public void setCadastro(Cadastro cadastro) {
        this.cadastro = cadastro;
    }

    public long getId() {
        return id;
    }

    public Login getLogin() {
        return login;
    }

    public StatusMembro getStatusMembro() {
        return statusMembro;
    }

    public boolean isSuspenso() {
        return suspenso;
    }

    public boolean isBanido() {
        return banido;
    }
    
    
    public HashSet<Incrito> getInscritos() {
        return inscritos;
    }

    public long getTotalInscritos() {
        return totalInscritos;
    }

    public Cadastro getCadastro() {
        return cadastro;
    }

    public void setImgMembro(BufferedImage imgMembro) {
        this.imgMembro = imgMembro;
    }

    public BufferedImage getImgMembro() {
        return imgMembro;
    }

    public void setId(long id) {
        this.id = id;
    }
    
    
    
}
