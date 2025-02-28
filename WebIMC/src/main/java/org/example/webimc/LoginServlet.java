package org.example.webimc;

import java.io.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import org.example.webimc.util.Usuario;

@WebServlet(name = "loginServlet", value = "/login-servlet")
public class LoginServlet extends HttpServlet {

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        System.out.println("[CHGOGU AQUI]");
        String usuario = request.getParameter("usuario");
        String senha = request.getParameter("senha");
        System.out.println("Usuario: " + usuario);
        System.out.println("Senha: " + senha);
        if(usuario!=null && senha !=null)
        {
            StringBuffer aux=new StringBuffer(usuario);
            aux=aux.reverse();
            System.out.println("[aux]" + aux);
            if(aux.toString().equals(senha))
            {
                // criar uma sessão e registrar os dados do usuário
                HttpSession httpSession=request.getSession();
                httpSession.setAttribute("usuario",new Usuario(usuario,"normal","ativo"));
                // redireciona para o módulo de cálculo do imc
                response.sendRedirect("cadastro-arquivo.jsp");
                return;
            }
        }
        response.sendRedirect("."); // volta para o form do login
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String usuario = request.getParameter("usuario");
        String senha = request.getParameter("senha");
        System.out.println("Usuario: " + usuario);
        System.out.println("Senha: " + senha);
        if(usuario!=null && senha !=null)
        {
            if(usuario.split("@")[0].equals(senha))
            {
                HttpSession httpSession=request.getSession();
                httpSession.setAttribute("usuario",new Usuario(usuario,"normal","ativo"));

                response.sendRedirect("cadastro-arquivo.jsp");
                return;
            }
        }
        response.sendRedirect(".");
    }
}