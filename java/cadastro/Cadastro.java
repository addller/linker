/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cadastro;

import java.sql.Date;
import perfil.Membro;
import perfil.Membro;

/**
 *
 * @author IE
 */
public class Cadastro {
    private long id;
    private Membro membro;
    private char sexo;
    private Date nascimento;
    private String nome;

    public Cadastro(Membro membro) {
        this.membro = membro;
    }
    
    public boolean validarCadastro(){
        throw new UnsupportedOperationException("Falta implementar");
    }
}
