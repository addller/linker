/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package perfil;

/**
 *
 * @author IE
 */
public class StatatusMembro {
    private long id, nivel;
    private String descricao, tipo;

    public StatatusMembro(long id, long nivel, String descricao, String tipo) {
        this.id = id;
        this.nivel = nivel;
        this.descricao = descricao;
        this.tipo = tipo;
    }
    
}
