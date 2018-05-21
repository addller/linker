package web;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.nio.charset.StandardCharsets;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.stream.Collectors;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import protocolo.Protocolo;

/**
 *
 * @author IE
 */
public enum Page {

    //CUIDAR PARA QUE OS CÓDIGOS NÃO SE REPITAM
    POST("post", 1000, Protocolo.Nivel.MEMBRO),
    CADASTRAR("cadastrar", 2000, Protocolo.Nivel.MEMBRO),
    TOPICO("topico", 3000, Protocolo.Nivel.VISITANTE),
    AUTO("auto", 4000, Protocolo.Nivel.MODERADOR),
    MAPS("maps", 5000, Protocolo.Nivel.VISITANTE),
    REDIRECT("redirect", 6000, Protocolo.Nivel.SYSTEM),
    HOME("home", 7000, Protocolo.Nivel.VISITANTE);

    public final String html, namePage;
    public final int codigo;
    public final Protocolo.Nivel nivel;

    private Page(String namePage, int codigo, Protocolo.Nivel nivel) {
        this.namePage = namePage;
        this.html = createPage(namePage + ".html");
        this.codigo = codigo;
        this.nivel = nivel;
    }

    private String createPage(String caminho) {
        try {
            InputStream pagina = Page.class.getResourceAsStream(caminho);
            return new BufferedReader(new InputStreamReader(pagina, StandardCharsets.UTF_8))
                    .lines()
                    .collect(Collectors.joining("\n"));
        } catch (Exception ex) {
            Logger.getLogger(Page.class.getName()).log(Level.SEVERE, null, ex);
            throw new IllegalArgumentException("Página não encontrada: " + caminho);
        }
    }

    private String replace(String target, String newValue, String html) {
        return html.replaceFirst("#" + target + "#", newValue);
    }

    public String redirect(Page page) {
        return Page.REDIRECT.html.replaceFirst("#page#", page.namePage);
    }

    public void redirect(PrintWriter out, HttpServletRequest request) {
        out.println(redirect((Page) request.getSession().getAttribute("#page#")));
    }

    public String redirect(String namePage) {
        return Page.REDIRECT.html.replaceFirst("#page#", namePage);
    }

    public final String replace(String[] targets, String[] values) {
        String newHtml = html;
        for (int i = 0; i < targets.length; i++) {
            newHtml = replace(targets[i], values[i], newHtml);
        }
        return newHtml;
    }

    public final String replace(String[][] targetVsValue) {
        String newHtml = html;
        for (String[] linha : targetVsValue) {
            newHtml = replace(linha[0], linha[1], newHtml);
        }
        return newHtml;
    }

    public final String replace(Map<String, String> targetVsValue) {
        String newHtml = html;
        for (String target : targetVsValue.keySet()) {
            newHtml = replace(target, targetVsValue.get(target), newHtml);
        }
        return newHtml;
    }

    /**
     * A chave do atributo a ser inserido na sessão é #page#,<br> Logo para
     * receber o valor use o mesmo atributo #page#.<br> Lembre que <strong>toda
     * vez que chamar este método</strong>
     * Esta manipulando os atributos da HttpSession, e portanto irá repor o
     * valor.<br>O Objeto inserido na sessão é do tipo enum Page,<br>
     * será o próprio objeto que chama este método e está listado nesta classe,
     * dentre as enumerações que forem criadas durante o desenvolvimento
     *
     * @param session sessão atual
     */
    public final void toSessionAtribute(HttpSession session) {
        session.setAttribute("#page#", this);
    }

    public final void toSessionAtribute(HttpServletRequest request) {
        toSessionAtribute(request.getSession());
    }
}
