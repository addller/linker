/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dao;

import acesso.Login;
import cadastro.Cadastro;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import perfil.Membro;

/**
 *
 * @author EI
 */
public class DAOCreate extends DAO {

    public DAOCreate(PrintWriter out, Connection conexao) {
        super(out, conexao);
    }

    public ResultSet registrarMembro(Membro membro) throws SQLException {
        Cadastro cadastro = membro.getCadastro();
        Login login = membro.getLogin();
        System.out.println(cadastro.getSexo()+" "+((int)cadastro.getSexo()));
        query("select id from registrarMembro(?,?,?,?,?,?) as id");
        encadear(new int[]{1, 4, 6}, cadastro.getNome(), login.getLoginName(), login.getEmail());
        statement.setDate(2, cadastro.getNascimento());
        statement.setString(3, String.valueOf(cadastro.getSexo()));
        statement.setBytes(5, login.getPass());
        return executeQuery(true);

    }

}
