/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dao;

/**
 *
 * @author IE
 */
public enum TypeBaseDados {
    AMAGO("jdbc:postgresql://localhost:5432/amago", "postgres", "jerre");
    public final String url, user, senha;
    public final String sgbd;

    private TypeBaseDados(String url, String user, String senha) {
        this.url = url;
        this.user = user;
        this.senha = senha;
        this.sgbd = url.replaceAll("jdbc:(.*)://.*", "$1");
    }

}
