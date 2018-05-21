/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package acesso;

import java.sql.ResultSet;
import java.sql.SQLException;
import protocolo.Protocolo;

/**
 *
 * @author IE
 */
public class Card {

    private final long idLogin,
            idMembro,
            idCadastro,
            idEndereco,
            key,
            code;
    private final Protocolo.Nivel nivel;

    public Card(ResultSet result, Protocolo.Nivel nivel) throws SQLException{
        result.next();
        this.idLogin = result.getLong("id_login");
        this.idMembro = result.getLong("id_membro");
        this.idCadastro = result.getLong("id_cadastro");
        this.idEndereco = result.getLong("id_endereco");
        this.key = KeyGenerator.generate(idLogin, idMembro);
        this.code = (long) (System.currentTimeMillis() + Math.random() * 1e6 - idMembro);
        this.nivel = nivel;
    }

    public long getIdLogin() {
        return idLogin;
    }

    public long getIdMembro() {
        return idMembro;
    }

    public long getKey() {
        return key;
    }

    public long getCode() {
        return code;
    }

    public Protocolo.Nivel getNivel() {
        return nivel;
    }

    public long getIdCadastro() {
        return idCadastro;
    }

    public long getIdEndereco() {
        return idEndereco;
    }
    
}
