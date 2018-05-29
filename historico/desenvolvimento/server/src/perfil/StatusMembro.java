/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package perfil;

import dao.BaseDados;
import dao.DAORead;
import dao.TypeBaseDados;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import publicacao.Categoria;

/**
 *
 * @author IE
 */
public enum StatusMembro {
    MEMBRO("Membro"),
    PATROCINADOR("Patrocinador"),
    MODERADOR("Moderador");

    public final Categoria categoria;
    public final int nivel;

    private StatusMembro(String categoria) {
        DAORead daoReader;
        try {
            daoReader = new DAORead(null, BaseDados.getConnection(TypeBaseDados.LINKER));
            ResultSet result = daoReader.loadStatusMembro(categoria);
            result.next();
            this.categoria = new Categoria(result.getLong("id"), result.getString("tipo"), result.getString("descricao"));
            this.nivel = result.getInt("nivel");
        } catch (SQLException ex) {
            Logger.getLogger(StatusMembro.class.getName()).log(Level.SEVERE, null, ex);
            throw new IllegalArgumentException("Categoria inexiste na base de dados: " + categoria);

        }

    }

}
