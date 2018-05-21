/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package protocolo;

/**
 *
 * @author IE
 */
public class SubProtocolo extends Protocolo {

    public SubProtocolo(Status status, String dados, String mensagem) {
        super.valueStatus(status, dados, mensagem);
    }

    public SubProtocolo(Status status, String dados) {
        super.valueStatus(status, dados);
    }

}
