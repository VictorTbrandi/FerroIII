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
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;

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

        String titulo   = request.getParameter("musicName");
        String estilo  = request.getParameter("musicGenre");
        String artista  = request.getParameter("artistName");

        // System.out.println(musicName + " " + musicGenre + " " + artistName);
        // String fileName = splitJoin(musicName) + "_" + splitJoin(musicGenre) + "_" + splitJoin(artistName) + ".mp3";
        // OutputStream out = null;
        // InputStream filecontent = null;

        // try {
        //     String path = this.getServletContext().getRealPath("/");
        //     File fpasta = new File(path + "/" + pasta);
        //     fpasta.mkdir();
        //     String var10004 = fpasta.getAbsolutePath();
        //     out = new FileOutputStream(new File(var10004 + "/" + fileName));
        //     filecontent = filePart.getInputStream();
        //     byte[] bytes = new byte[1024];

        //     int read;
        //     while((read = filecontent.read(bytes)) != -1) {
        //         out.write(bytes, 0, read);
        //     }
        //     out.close();
        //     filecontent.close();
        //     response.sendRedirect(request.getContextPath() + "/");
        // } catch (Exception e) {
        //     System.out.println(e.getMessage());
        // }

        String fileName = filePart.getSubmittedFileName();

        URL url = new URL("http://localhost:8080/apis/music-upload");
        HttpURLConnection connection = (HttpURLConnection) url.openConnection();
        connection.setDoOutput(true);
        connection.setRequestMethod("POST");

        String boundary = "----WebKitFormBoundary7MA4YWxkTrZu0gW";
        connection.setRequestProperty("Content-Type", "multipart/form-data; boundary=" + boundary);

        OutputStream outputStream = connection.getOutputStream();
        PrintWriter writer = new PrintWriter(new OutputStreamWriter(outputStream, "UTF-8"), true);

        writer.append("--").append(boundary).append("\r\n");
        writer.append("Content-Disposition: form-data; name=\"titulo\"").append("\r\n\r\n");
        writer.append(titulo).append("\r\n");

        writer.append("--").append(boundary).append("\r\n");
        writer.append("Content-Disposition: form-data; name=\"artista\"").append("\r\n\r\n");
        writer.append(artista).append("\r\n");

        writer.append("--").append(boundary).append("\r\n");
        writer.append("Content-Disposition: form-data; name=\"estilo\"").append("\r\n\r\n");
        writer.append(estilo).append("\r\n");

        writer.append("--").append(boundary).append("\r\n");
        writer.append("Content-Disposition: form-data; name=\"file\"; filename=\"" + fileName + "\"").append("\r\n");
        writer.append("Content-Type: " + filePart.getContentType()).append("\r\n\r\n");
        writer.flush();

        InputStream inputStream = filePart.getInputStream();
        byte[] buffer = new byte[4096];
        int bytesRead;
        while ((bytesRead = inputStream.read(buffer)) != -1) {
            outputStream.write(buffer, 0, bytesRead);
        }
        outputStream.flush();
        writer.append("\r\n");
        writer.flush();

        writer.append("--").append(boundary).append("--").append("\r\n");
        writer.close();
        inputStream.close();

        int responseCode = connection.getResponseCode();
        if (responseCode == HttpURLConnection.HTTP_OK) {
            response.sendRedirect(request.getContextPath() + "/cadastro-arquivo.jsp");
        } else {
            response.getWriter().println("Erro ao realizar upload. Código HTTP: " + responseCode);
        }

    }
}
