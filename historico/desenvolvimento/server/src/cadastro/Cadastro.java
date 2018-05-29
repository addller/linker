/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cadastro;

import ferramentas.Validacao;
import interfaces.Validavel;
import java.sql.Date;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;

/**
 *
 * @author IE
 */
public class Cadastro implements Validavel{

    private long id;
    private final char sexo;
    private final Date nascimento;
    private final String nome;

    public Cadastro(String nome, LocalDate nascimento, char sexo) {
        this.sexo = sexo;
        this.nascimento = Date.valueOf(nascimento);
        this.nome = nome;
    }

    public Cadastro(ResultSet result) throws SQLException {
        this(result.getString("nome"), result.getDate("nascimento").toLocalDate(), result.getString("sexo").charAt(0));       
    }
    
    

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public char getSexo() {
        return sexo;
    }

    public Date getNascimento() {
        return nascimento;
    }

    public String getNome() {
        return nome;
    }

    @Override
    public Validacao validar() {
        //long idade = ChronoUnit.YEARS.between(Validacao.now().toInstant(), nascimento.toInstant());
        return Validacao.validar(
                new Validacao( nome.length() > 2,"O nome informado é muito curto"),
                new Validacao(sexo == 'F' || sexo =='M', "O sexo deve ser F(feminino) ou M(masculino)")//,
                //new Validacao(idade > 17, "A idade mínima para participar da plataforma é 18 anos")
        );
    }

    

    
}
