/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dao;

import java.io.Closeable;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 *
 * @author EI
 */
public class BaseDados implements Closeable {

    private final DAOCreate create;
    private final DAORead read;
    private final DAOUpdate update;
    private final DAODelete delete;

    private final Connection conexao;
    private final PrintWriter out;

    public BaseDados(PrintWriter out, Connection conexao) {
        this.out = out;
        this.conexao = conexao;
        create = new DAOCreate(out, conexao);
        read = new DAORead(out, conexao);
        update = new DAOUpdate(out, conexao);
        delete = new DAODelete(out, conexao);
    }

    public DAOCreate create() {
        return create;
    }

    public DAORead read() {
        return read;
    }

    public DAOUpdate update() {
        return update;
    }

    public DAODelete delete() {
        return delete;
    }

    @Override
    public void close() {
        DAO[] itens = {create, read, update, delete};
        for (DAO item : itens) {
            if (item != null) {
                item.close();
                break;
            }
        }
    }

    /**
     * Conecta a um dos bancos de dados disponíveis
     *
     * @param baseDados disponíveis
     * @return conexao com o SGBD solicitado
     * @throws java.sql.SQLException
     */
    public static Connection getConnection(TypeBaseDados baseDados) throws SQLException {
        return DriverManager.getConnection(baseDados.url, baseDados.user, baseDados.senha);
    }

}
