<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.io.File" %>
<%@ page import="java.util.Arrays" %>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Music Player</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <style>
        .filter-label {
            font-size: 1.2rem;
            color: #007bff;
            font-weight: bold;
            padding: 8px 12px;
            background: #f8f9fa;
            border-left: 4px solid;
            display: inline-block;
            border-radius: 4px;
        }

        .btn-custom {
            font-size: 1.1rem;
            font-weight: bold;
            padding: 10px 20px;
            color: #fff;
            background-color: #0056b3;
            border: 2px solid #fff;
            border-radius: 50px;
            text-transform: uppercase;
            box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.2);
            transition: all 0.3s ease-in-out;
            text-decoration: none;
            display: inline-block;
        }

        .btn-custom:hover {
            background-color: #003d80;
            color: #f8f9fa;
            transform: scale(1.05);
            box-shadow: 4px 4px 15px rgba(0, 0, 0, 0.3);
        }

        /* Responsividade e formatação fixa para a tabela */
        .table-responsive {
            margin-top: 20px;
        }
        .table-fixed {
            table-layout: fixed;
            width: 100%;
        }
        .table-fixed th, .table-fixed td {
            width: 25%;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
    </style>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
    <div class="container-fluid">
        <span class="navbar-brand mb-0 h1">PlayMySongs</span>
        <div>
            <%
                HttpSession sessao = request.getSession(false);
                boolean usuarioLogado = (sessao != null && sessao.getAttribute("usuario") != null);
            %>
            <a href="<%= usuarioLogado ? "cadastro-arquivo.jsp" : "login.html" %>" class="btn btn-custom">
                🎵 Enviar Músicas
            </a>
        </div>
    </div>
</nav>

<div class="container mt-4">
    <h2>My Playlist</h2>
    <h3 class="filter-label">🔍 Filtros: Título, Estilo e Artista</h3>

    <form class="row g-3 mb-4" method="get" action="index.jsp">
        <div class="col-auto">
            <input
                    type="text"
                    class="form-control"
                    name="filter"
                    placeholder="Pesquisar"
                    value="<%= request.getParameter("filter") != null ? request.getParameter("filter") : "" %>"
            />
        </div>
        <div class="col-auto">
            <button type="submit" class="btn btn-primary">Buscar</button>
        </div>
    </form>

    <%
        String filtro = request.getParameter("filter");
        if (filtro == null) {
            filtro = "";
        }

        File pastaweb = new File(request.getServletContext().getRealPath("") + "/destination");

        if (pastaweb.exists() && pastaweb.isDirectory() && pastaweb.listFiles() != null && pastaweb.listFiles().length > 0) {
    %>

    <div class="table-responsive">
        <table class="table table-striped table-fixed mt-3">
            <thead>
            <tr>
                <th>Nome da Música</th>
                <th>Gênero</th>
                <th>Artista</th>
                <th>Player</th>
            </tr>
            </thead>
            <tbody>
            <%
                for (File file : pastaweb.listFiles()) {
                    if (file.isFile()) {
                        String nomeArquivo = file.getName();
                        // Verifica se o arquivo é mp3
                        if (!nomeArquivo.toLowerCase().endsWith(".mp3")) {
                            continue;
                        }
                        if (!filtro.isEmpty() && !nomeArquivo.toLowerCase().contains(filtro.toLowerCase())) {
                            continue;
                        }

                        // Remove a extensão e separa por "_"
                        String nomeSemExtensao = nomeArquivo.substring(0, nomeArquivo.lastIndexOf("."));
                        String[] partes = nomeSemExtensao.split("_");
                        String nomeMusica = partes.length > 0 ? partes[0] : nomeArquivo;
                        String genero = partes.length > 1 ? partes[1] : "";
                        String artista = partes.length > 2 ? partes[2] : "";
            %>
            <tr>
                <td title="<%= nomeMusica %>"><%= nomeMusica %></td>
                <td title="<%= genero %>"><%= genero %></td>
                <td title="<%= artista %>"><%= artista %></td>
                <td>
                    <audio controls class="audio-player" style="width: 100%">
                        <source src="<%= request.getContextPath() + "/download-servlet?file=" + nomeArquivo %>" type="audio/mpeg" />
                        Seu navegador não suporta HTML5 audio.
                    </audio>
                </td>
            </tr>
            <%
                    }
                }
            %>
            </tbody>
        </table>
    </div>

    <%
    } else {
    %>
    <div class="alert alert-danger mt-3" role="alert">
        Diretório não encontrado ou caminho inválido.
    </div>
    <%
        }
    %>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const players = document.querySelectorAll(".audio-player");
        players.forEach(player => {
            player.addEventListener("play", function () {
                players.forEach(otherPlayer => {
                    if (otherPlayer !== player) {
                        otherPlayer.pause();
                        otherPlayer.currentTime = 0;
                    }
                });
            });
        });
    });
</script>
</body>
</html>
