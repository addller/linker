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
import perfil.Membro;


/**
 *
 * @author EI
 */
public class DAOCreate extends DAO{

    public DAOCreate(PrintWriter out, Connection conexao) {
        super(out, conexao);
    }
  
    public ResultSet registrarMembro(Membro membro) throws SQLException {
        throw new IllegalArgumentException("Falta implementar");
    }

}
