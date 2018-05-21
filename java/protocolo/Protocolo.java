/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package protocolo;

import java.util.logging.Level;
import java.util.logging.Logger;
import org.json.JSONException;
import org.json.JSONObject;

/**
 *
 * @author IE
 */
public class Protocolo {

    private JSONObject json;

    public static enum Type {
        REQUEST(0, "request"),
        RESPONSE(1, "response"),
        UPDATE(2, "update");
        public final int nivel;
        public final String lowerName;

        private Type(int nivel, String lowerName) {
            this.nivel = nivel;
            this.lowerName = lowerName;
        }
    }

    public static enum Action {
        CREATE(0, "create"),
        READ(1, "read"),
        UPDATE(2, "update"),
        DELETE(3, "delete");
        public final int nivel;
        public final String lowerName;

        private Action(int nivel, String lowerName) {
            this.nivel = nivel;
            this.lowerName = lowerName;
        }
    }

    public static enum Target {
        LOGIN(0, "login"),
        POSTAGEM(100, "postagem"),
        OTHER(9999, "other");
        public final int nivel;
        public final String lowerName;

        private Target(int nivel, String lowerName) {
            this.nivel = nivel;
            this.lowerName = lowerName;

        }
    }

    public static enum Status {
        INFORMATIONAL(1, "informational"),
        SUCCES(2, "succes"),
        REDIRECT(3, "redirect"),
        CLIENT_ERROR(4, "cliente_error"),
        SERVER_ERROR(5, "server_error");
        public final int nivel;
        public final String lowerName;

        private Status(int nivel, String lowerName) {
            this.nivel = nivel;
            this.lowerName = lowerName;
        }
    }

    public static enum Nivel {
        DESCONHECIDO(0, "desconhecido"),
        EXTERNO(1, "externo"),
        VISITANTE(2, "visitante"),
        USUARIO(3, "usuario"),
        MEMBRO(100, "membro"),
        MODERADOR(200, "moderador"),
        INTERNO(300, "interno"),
        SYSTEM(9000, "system");

        public final int nivel;
        public final String lowerName;

        private Nivel(int nivel, String lowerName) {
            this.nivel = nivel;
            this.lowerName = lowerName;
        }

        public static final Nivel findNivel(int nivel) {
            for (Nivel value : Nivel.values()) {
                if (nivel == value.nivel) {
                    return value;
                }
            }
            return DESCONHECIDO;
        }
    }

    public Protocolo() {
    }

    public Protocolo(Type Type, Action action, Target target) {
        config(Type, action, target);
    }

    public String valueStatus(Status status, String dados) {
        return valueStatus(status, dados, null);
    }

    public String valueStatus(Status status, String dados, String mensagem) {
        try {
            if (json == null) {
                json = new JSONObject();
            }
            json.put("status", status.lowerName);
            json.put("dados", dados);
            if (mensagem != null) {
                json.put("mensagem", mensagem);
            }
        } catch (JSONException ex) {
            Logger.getLogger(Protocolo.class.getName()).log(Level.SEVERE, null, ex);
        }
        return json.toString();
    }

    public String valueNivel(Nivel nivel) {
        try {
            json.put("nivel", nivel.lowerName);
        } catch (JSONException ex) {
            Logger.getLogger(Protocolo.class.getName()).log(Level.SEVERE, null, ex);
        }
        return json.toString();
    }

    public final void config(Type Type, Action action, Target target) {
        try {
            json = new JSONObject();
            json.put("type", Type.lowerName);
            json.put("action", action.lowerName);
            json.put("target", target.lowerName);
        } catch (JSONException ex) {
            Logger.getLogger(Protocolo.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public JSONObject getJson() {
        return json;
    }

    @Override
    public String toString() {
        return json.toString();
    }
}
