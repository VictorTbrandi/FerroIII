package org.example.webimc;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;

@MultipartConfig(
        fileSizeThreshold = 1048576,
        maxFileSize = 104857600L,
        maxRequestSize = 104857600L
)
@WebServlet(
        name = "UploadServlet",
        value = "/upload-servlet"
)
public class UploadServlet extends HttpServlet {

    private String splitJoin(String str){
        return String.join(" ", str.trim().split("_")).trim();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pasta = "destination";
        Part filePart = request.getPart("musicFile");

        String musicName   = request.getParameter("musicName");
        String musicGenre  = request.getParameter("musicGenre");
        String artistName  = request.getParameter("artistName");
        System.out.println(musicName + " " + musicGenre + " " + artistName);
        String fileName = splitJoin(musicName) + "_" + splitJoin(musicGenre) + "_" + splitJoin(artistName) + ".mp3";
        OutputStream out = null;
        InputStream filecontent = null;
        PrintWriter writer = response.getWriter();

        try {
            String var10002 = this.getServletContext().getRealPath("/");
            File fpasta = new File(var10002 + "/" + pasta);
            fpasta.mkdir();
            String var10004 = fpasta.getAbsolutePath();
            out = new FileOutputStream(new File(var10004 + "/" + fileName));
            filecontent = filePart.getInputStream();
            byte[] bytes = new byte[1024];

            int read;
            while((read = filecontent.read(bytes)) != -1) {
                out.write(bytes, 0, read);
            }

            writer.println("<script>alert(Novo arquivo " + fileName + " criado na pasta " + pasta + ")</script>");
            out.close();
            filecontent.close();
            writer.close();
        } catch (Exception var12) {
            writer.println("Erro ao receber o arquivo");
            writer.println("<br/> ERRO: " + var12.getMessage());
        }

    }
}
