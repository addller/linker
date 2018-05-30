/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dao;


import ferramentas.EscalaImagem;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import perfil.Membro;

/**
 *
 * @author EI
 */
public class DAORead extends DAO {

    public DAORead(PrintWriter out, Connection conexao) {
        super(out, conexao);
    }
    
    public ResultSet loadStatusMembro(String tipo) throws SQLException{
        query("select * from _consultarStatusMembro(?)");
        statement.setString(1, tipo);
        return executeQuery();
    }
    
    public ResultSet logar(String loginName, byte[] pass) throws SQLException{
        query("select * from _logar(?,?) as membro;");
        encadear(loginName);
        statement.setBytes(2, pass);
        return executeQuery(true);
    }
    public ResultSet getImagemPerfil(Membro membro, EscalaImagem escala) throws SQLException {
        query("select * from _getImagemPerfil(?,?) as imagem");
        statement.setLong(1, membro.getId());
        statement.setString(2, escala.toString());
        return executeQuery();
    }


}
