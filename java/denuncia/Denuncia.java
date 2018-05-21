/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package denuncia;

import perfil.Membro;
import publicacao.Postagem;

/**
 *
 * @author IE
 */
public class Denuncia {

    private long id;
    private Postagem postagem;
    private Membro denunciante;
    private TipoDenuncia tipoDenuncia;

    public Denuncia(long id, Postagem postagem, Membro denunciante, TipoDenuncia tipoDenuncia) {
        this.id = id;
        this.postagem = postagem;
        this.denunciante = denunciante;
        this.tipoDenuncia = tipoDenuncia;
    }

    

    public void atualizarDenuncias(Denuncia denunca) {
    }

    public void suspenderMembro(Membro membro) {
    }
}
