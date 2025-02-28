<%@ page import="java.io.File" %>
<%@ page import="java.util.Arrays" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <title>Listagem de Arquivos</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container-fluid">
        <span class="navbar-brand mb-0 h1">Meu Projeto</span>
        <div>
            <a href="cadastro-arquivo.jsp" class="btn btn-outline-light">
                Fazer Upload
            </a>
        </div>
    </div>
</nav>

<div class="container mt-4">
    <h2>Arquivos no Diretório</h2>
    <form class="row g-3 mb-4" method="get" action="index.jsp">
        <div class="col-auto">
            <input
                    type="text"
                    class="form-control"
                    name="filter"
                    placeholder="Buscar por nome"
                    value="<%= request.getParameter("filter") != null ? request.getParameter("filter") : "" %>"
            />
        </div>
        <div class="col-auto">
            <button type="submit" class="btn btn-primary">Buscar</button>
        </div>
    </form>
    <%

        // Recebe o parâmetro de busca
        String filtro = request.getParameter("filter");
        if (filtro == null) {
            filtro = "";
        }

        File pastaweb = new File(request.getServletContext().getRealPath("") + "/destination");

        if (pastaweb.exists() && pastaweb.isDirectory() && pastaweb.listFiles() != null && pastaweb.listFiles().length > 0) {
    %>
    <table class="table table-striped mt-3">
        <thead>
        <tr>
            <th>Nome do Arquivo</th>
            <th>Tamanho (bytes)</th>
            <th>Player</th>
        </tr>
        </thead>
        <tbody>
        <%
            for (File file : pastaweb.listFiles()) {
                if (file.isFile()) { // se é um arquivo e não uma pasta
                    String nomeArquivo = file.getName();

                    // Aplica o filtro (case-insensitive)
                    if (!filtro.isEmpty() &&
                            !nomeArquivo.toLowerCase().contains(filtro.toLowerCase())) {
                        continue; // pula se não combinar
                    }

        %>
        <tr>
            <td><%= file.getName() %>
            </td>
            <td><%= file.length() %>
            </td>
            <td>
                <audio controls style="width: 180px;">
                    <source
                            src="<%= request.getContextPath() + "/download-servlet?file=" + nomeArquivo %>"
                            type="audio/mpeg"
                    />
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

<!-- Bootstrap 5 JS (opcional, caso precise de interatividade) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
