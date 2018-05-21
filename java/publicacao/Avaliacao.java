/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package publicacao;

import perfil.Membro;

/**
 *
 * @author IE
 */
public class Avaliacao{
    private long id;
    private long positiva,
            negativa;
    private Membro avaliador;
    private Avaliavel avaliavel;

    public Avaliacao(long positiva, long negativa, Membro avaliador, Avaliavel avaliavel) {
        this.positiva = positiva;
        this.negativa = negativa;
        this.avaliador = avaliador;
        this.avaliavel = avaliavel;
    }
}
