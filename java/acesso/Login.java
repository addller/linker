/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package acesso;

import perfil.Membro;

/**
 *
 * @author IE
 */
public class Login {
    private long id;
    private String email, loginName;
    private byte[] pass;

    public Login(String email, String loginName, byte[] pass) {
        this.email = email;
        this.loginName = loginName;
        this.pass = pass;
    }
    
     public Card autenticar(Membro membro) {
        throw new UnsupportedOperationException("falta implementar a função");
    }
    
}
