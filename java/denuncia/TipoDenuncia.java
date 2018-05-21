/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package denuncia;

/**
 *
 * @author IE
 */
class TipoDenuncia {
    private long id;
    private String tipo,
            descricao;

    public TipoDenuncia(long id, String tipo, String descricao) {
        this.id = id;
        this.tipo = tipo;
        this.descricao = descricao;
    }
    
    
}
