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
public class CategoriaPostagem {
    private long id;
    private Categoria categoria;
    private Postagem postagem;

    public CategoriaPostagem(long id, Categoria categoria, Postagem postagem) {
        this.id = id;
        this.categoria = categoria;
        this.postagem = postagem;
    }
    
}
