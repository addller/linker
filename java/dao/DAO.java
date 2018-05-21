/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dao;

import java.io.Closeable;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.stream.IntStream;

/**
 *
 * @author EI
 */
public abstract class DAO implements Closeable{

    protected final Connection conexao;
    protected PreparedStatement statement;
    protected ResultSet result;
    private final PrintWriter out;

    public DAO(PrintWriter out, Connection conexao) {
        this.conexao = conexao;
        this.out = out;
    }

    public void encadear(int[] posicoes, String... dados) throws SQLException {
        for (int i = 0; i < dados.length; i++) {
            statement.setString(posicoes[i], dados[i]);
        }

    }

    public void encadear(int[] posicoes, long... dados) throws SQLException {
        for (int i = 0; i < dados.length; i++) {
            statement.setLong(posicoes[i], dados[i]);
        }

    }

    public void encadear(long... dados) throws SQLException {
        encadear(IntStream.rangeClosed(1, dados.length).toArray(), dados);
    }

    public void encadear(String... dados) throws SQLException {
        encadear(IntStream.rangeClosed(1, dados.length).toArray(), dados);
    }

    protected static String selectFrom(String table, String condicao, String... columns) {
        StringBuilder cols = new StringBuilder("SELECT ");
        int len = columns.length;
        if (len == 0) {
            cols.append("* FROM ").append(table).append(" ").append(condicao);
            return cols.toString();
        }

        for (int i = 0; i < len; i++) {
            cols.append(columns[i]);
            if (i + 1 < len) {
                cols.append(", ");
            }
        }
        cols.append(" FROM ").append(table).append(" ").append(condicao);
        return cols.toString();
    }

    public boolean begin() {
        try {
            statement = conexao.prepareStatement("BEGIN");
            return true;
        } catch (SQLException ex) {
            Logger.getLogger(DAO.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        }
    }

    public void commit() throws SQLException {
        statement = conexao.prepareStatement("COMMIT");
        statement.execute();
    }

    public void rollBack() {
        try {
            statement = conexao.prepareStatement("ROLLBACK");
            statement.execute();
        } catch (SQLException ex) {
            Logger.getLogger(DAO.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public PrintWriter gerOut() {
        return out;
    }

    @Override
    public void close() {
        try {
            result.close();
        } catch (SQLException ex) {
            Logger.getLogger(DAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        try {
            statement.close();
        } catch (SQLException ex) {
            Logger.getLogger(DAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        try {
            conexao.close();
        } catch (SQLException ex) {
            Logger.getLogger(DAO.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    protected void query(String query) throws SQLException {
        statement = conexao.prepareStatement(query + ";");
    }

    protected ResultSet executeQuery() throws SQLException {
        result = statement.executeQuery();
        return result;
    }

    public ResultSet getResult() {
        return result;
    }
    

}
