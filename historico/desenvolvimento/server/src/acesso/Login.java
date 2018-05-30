/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package acesso;

import ferramentas.Validacao;
import interfaces.Validavel;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 *
 * @author IE
 */
public class Login implements Validavel {

    private final String email, loginName;
    private final byte[] pass;

    public Login(String email, String loginName, byte[] pass) {
        this.email = email;
        this.loginName = loginName;
        this.pass = pass;
    }

    public Login(ResultSet result) throws SQLException {
        this(result.getString("email"), result.getString("login_name"), result.getBytes("pass"));
    }

    @Override
    public Validacao validar() {
        String passe = new String(pass);

        return Validacao.validar(
                new Validacao(email.length() > 4 && email.contains("@"), "Email inválido"),
                new Validacao(loginName.length() > 7, "O login name deve possuir no mínimo oito caracteres"),
                new Validacao(passe.length() > 7, "A senha deve ter no mínimo 8 caracteres"),
                new Validacao(passe.matches(".*[a-z]+.*"), "A senha ao menos uma letra minúscula"),
                new Validacao(passe.matches(".*[A-Z]+.*"), "A senha ao menos uma letra maiúscula"),
                new Validacao(passe.matches(".*[0-9]+.*"), "A senha ao menos um número"),
                new Validacao(passe.matches(".*[?!@#$%&*-_]+.*"), "Informe um dos seguintes caracteres especiais em sua senha: ?!@#$%&*-_")
        );
    }

    public String getEmail() {
        return email;
    }

    public String getLoginName() {
        return loginName;
    }

    public byte[] getPass() {
        return pass;
    }

}
