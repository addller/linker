/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dao;

import acesso.Login;
import cadastro.Cadastro;
import ferramentas.EscalaImagem;
import java.awt.Graphics2D;
import java.awt.Image;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.imageio.ImageIO;
import perfil.Membro;

/**
 *
 * @author EI
 */
public class DAOCreate extends DAO {

    public DAOCreate(PrintWriter out, Connection conexao) {
        super(out, conexao);
    }

    public ResultSet registrarMembro(Membro membro) throws SQLException {
        Cadastro cadastro = membro.getCadastro();
        Login login = membro.getLogin();
        System.out.println(cadastro.getSexo() + " " + ((int) cadastro.getSexo()));
        query("select id from registrarMembro(?,?,?,?,?,?) as id");
        encadear(new int[]{1, 4, 6}, cadastro.getNome(), login.getLoginName(), login.getEmail());
        statement.setDate(2, cadastro.getNascimento());
        statement.setString(3, String.valueOf(cadastro.getSexo()));
        statement.setBytes(5, login.getPass());
        return executeQuery(true);

    }

    public ResultSet registrarImagemPerfil(Membro membro, EscalaImagem escala) throws SQLException, IOException {
        ByteArrayOutputStream bos = new ByteArrayOutputStream();
        ImageIO.write(ajustarImagem(membro.getImgMembro(), escala), "jpg", bos);
        query("select id from registrarImagemPerfil(?,?,?) as id");
        statement.setLong(1, membro.getId());
        statement.setBytes(2, bos.toByteArray());
        statement.setString(3, escala.toString());
        return executeQuery(true);
    }

    private BufferedImage ajustarImagem(BufferedImage imagem, EscalaImagem escala) {
        int largura = imagem.getWidth(),
                altura = imagem.getHeight();
        double impPercentualPequena = (double) 100 / largura,
                imgPercentualMedia = (double) 500 / largura;
        switch (escala) {
            case PEQUENA:
                return ajustarImagem(imagem, largura * impPercentualPequena, altura * impPercentualPequena);
            case MEDIA:
                return ajustarImagem(imagem, largura * imgPercentualMedia, altura * imgPercentualMedia);
            default:
                return imagem;
        }
    }

    private BufferedImage ajustarImagem(BufferedImage image, double largura, double altura) {
        int xLargura = (int) largura,
                yAltura = (int) altura;
        BufferedImage novaImagem = new BufferedImage(xLargura, yAltura, BufferedImage.TYPE_INT_RGB);
        Graphics2D g = (Graphics2D) novaImagem.getGraphics();
        g.drawImage(image, 0, 0, xLargura, yAltura, null);
        return novaImagem;
    }

}
