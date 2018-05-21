/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package publicacao;

import java.sql.Date;
import perfil.Membro;

/**
 *
 * @author IE
 */
public class Comentario implements Avaliavel{
    private long id;
    private Postagem postagem;
    private boolean isEditado;
    private Date dataPostagem;
    private String comentario;
    private Membro remetente;

    @Override
    public void avaliar(Avaliacao avaliacao) {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public void removeAvaliacao(Avaliacao avaliacao) {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }
}
