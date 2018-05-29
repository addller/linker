/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ferramentas;

import java.sql.Date;

/**
 *
 * @author IE
 */
public class Validacao {

    private final String mensagem;
    private final boolean valida;

    public Validacao(boolean validacao, String mensagem) {
        this.mensagem = mensagem;
        this.valida = validacao;
    }
    
    

    public String getMensagem() {
        return mensagem;
    }

    public boolean isValida() {
        return valida;
    }
    
    public static Date now() {
        return new Date(System.currentTimeMillis());
    }

    public static Validacao validar(Validacao... validacoes) throws IllegalArgumentException {
        if (validacoes.length == 0) {
            throw new IllegalArgumentException("Não foi informado nenhuma validação");
        }
        for (Validacao validar : validacoes) {
            if (!validar.isValida()) {
                return validar;
            }
        }
        return new Validacao(true, "OK");
    }

}
