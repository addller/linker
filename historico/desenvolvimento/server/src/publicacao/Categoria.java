/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package publicacao;

/**
 *
 * @author IE
 */
public class Categoria {
    private final long id;
    private final String categoria, descricao;

    public Categoria(long id, String categoria, String descricao) {
        this.id = id;
        this.categoria = categoria;
        this.descricao = descricao;
    }

    public long getId() {
        return id;
    }

    public String getCategoria() {
        return categoria;
    }

    public String getDescricao() {
        return descricao;
    }
    
    
}
