package org.example.webimc;

import jakarta.servlet.http.HttpServlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.*;

@WebServlet("/download-servlet")
public class DownloadServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String fileName = request.getParameter("file");
        if (fileName == null || fileName.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Nome de arquivo ausente ou inválido");
            return;
        }
        String realPath = getServletContext().getRealPath("") + "/destination";
        File file = new File(realPath, fileName);
        if (!file.exists() || !file.isFile()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Arquivo não encontrado");
            return;
        }
        response.setContentType("audio/mpeg");
        response.setHeader("Content-Length", String.valueOf(file.length()));

        try (FileInputStream in = new FileInputStream(file);
             OutputStream out = response.getOutputStream()) {
            byte[] buffer = new byte[4096];
            int bytesRead;
            while ((bytesRead = in.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }
        }
    }
}
