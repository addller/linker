/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dao;

import java.io.PrintWriter;
import java.sql.Connection;

/**
 *
 * @author EI
 */
public class DAOUpdate extends DAO{
    
    public DAOUpdate(PrintWriter out, Connection conexao) {
        super(out, conexao);
    }
    
}
