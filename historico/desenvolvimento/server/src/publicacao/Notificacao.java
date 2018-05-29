/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package publicacao;

import perfil.Membro;

/**
 *
 * @author IE
 */
public class Notificacao {

    private long id;
    private Postagem postagem;
    private Membro destinatario;

    public Notificacao(long id, Postagem postagem, Membro destinatario) {
        this.id = id;
        this.postagem = postagem;
        this.destinatario = destinatario;
    }

    public void notificarInstrito() {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

}
