/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dao;


import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;

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

    public ResultSet findMembroByName(String nome, String... columns) throws SQLException {
        query(selectFrom("cadastro_membro", "where nome_membro like ?", columns));
        statement.setString(1, "%" + nome + "%");
        return executeQuery();
    }

    public ResultSet findCadastroMembroByIdProprietario(long id, String... columns) throws SQLException {
        query(selectFrom("cadastro_membro", "where id_proprietario = ? limit 1", columns));
        statement.setLong(1, id);
        return executeQuery();
    }

    public ResultSet findCadastroByIdProprietario(int limit, long idProprietario, String... columns) throws SQLException {
        query(selectFrom("cadastro", "where id_proprietario = ? limit " + limit, columns));
        statement.setLong(1, idProprietario);
        return executeQuery();
    }

    public ResultSet findCadastroMembroById(long idMembro, String... columns) throws SQLException {
        query(selectFrom("cadastro_membro", "where id = ? limit 1", columns));
        statement.setLong(1, idMembro);
        return executeQuery();
    }

    public ResultSet findLoginByEmail(Connection conexao, String email, String... columns) throws SQLException {
        query(selectFrom("login", "where email = ? limit 1" + " from login ", columns));
        statement.setString(1, email);
        return executeQuery();
    }

    public ResultSet findLoginByLoginName(String loginName, String... columns) throws SQLException {

        query(selectFrom("login", "where login_name = ? limit 1", columns));
        statement.setString(1, loginName);
        return executeQuery();
    }

    public ResultSet listarAmizades(long idMembro) throws SQLException {
        query(selectFrom("amizade", "where id_requisitante = ? or id_requisitado = ?"));
        encadear(idMembro, idMembro);
        return executeQuery();
    }

    public ResultSet findAmigo(long requisitante, long requisitado, String ... columns) throws SQLException {
        String condicao = "where id_requisitante = ? and id_requisitado = ? or id_requisitante = ? and id_requisitado = ?";
        query(selectFrom("amizade", condicao, columns));
        encadear(requisitante, requisitado, requisitado, requisitante);
        return executeQuery();
    }

    public ResultSet listarMembrosPorNome(String nomeProcurado) throws SQLException {
        query(selectFrom("membro", "where nome_membro = %?%", "id", "nome_membro"));
        statement.setString(1, nomeProcurado);
        return executeQuery();
    }

}
