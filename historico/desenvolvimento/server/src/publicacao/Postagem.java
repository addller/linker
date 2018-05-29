/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package publicacao;

import perfil.Membro;
import denuncia.Denuncia;

/**
 *
 * @author IE
 */
public class Postagem implements Avaliavel{
    private long id;
    private Membro membro;
    private String[] vetorUrlVideo,
            urlImagem,
            urlSite,
            palavrasChave[];
    private String patrocinador;
    private String descricao,
            titulo;
    private Classificacao classificacao;

    public Postagem(long id, Membro membro, String titulo, Classificacao classificacao) {
        this.id = id;
        this.membro = membro;
        this.titulo =titulo;
        this.classificacao = classificacao;
    }

    @Override
    public void avaliar(Avaliacao avaliacao) {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public void removeAvaliacao(Avaliacao avaliacao) {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }
    
    public void comentarPostagem(String texto){}
    
    public boolean validarPostagem(){
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.    
    }
}
