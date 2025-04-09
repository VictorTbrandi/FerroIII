<%@ page contentType="text/html; charset=UTF-8" %>
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
        .table-responsive { margin-top: 20px; }
        .table-fixed { table-layout: fixed; width: 100%; }
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

    <form id="searchForm" class="row g-3 mb-4">
        <div class="col-auto">
            <input type="text" class="form-control" name="filter" placeholder="Pesquisar" />
        </div>
        <div class="col-auto">
            <button type="submit" class="btn btn-primary">Buscar</button>
        </div>
    </form>

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
            <tbody id="musicasBody">
            </tbody>
        </table>
    </div>
</div>

<script>
    function fetchMusicas(chave) {
        let url = "http://localhost:8080/apis/musics";
        if (chave && chave.trim() !== "") {
            url += "?chave=" + encodeURIComponent(chave);
        }
        fetch(url)
            .then(response => {
                if (!response.ok) {
                    throw new Error("Nenhuma música encontrada ou erro no servidor");
                }
                return response.json();
            })
            .then(data => {
                populateTable(data);
            })
            .catch(error => {
                console.error("Erro ao buscar músicas:", error);
                document.getElementById("musicasBody").innerHTML =
                    '<tr><td colspan="4" class="text-center text-danger">' + error.message + "</td></tr>";
            });
    }

    function onPlayAudio(e) {
        const players = document.getElementsByTagName("audio")
        for (let i = 0; i < players.length; i++) {
            const otherPlayer = players[i];
            if (!otherPlayer.paused && otherPlayer.id !== e.target.id) {
                otherPlayer.pause();
                otherPlayer.currentTime = 0;
            }
        }
    }

    function populateTable(musicas) {
        const tbody = document.getElementById("musicasBody");
        tbody.innerHTML = "";
        musicas.forEach((musica, i) => {
            const tr = document.createElement("tr");

            const tdNome = document.createElement("td");
            tdNome.textContent = musica.titulo;
            tdNome.title = musica.titulo;
            tr.appendChild(tdNome);

            const tdGenero = document.createElement("td");
            tdGenero.textContent = musica.estilo;
            tdGenero.title = musica.estilo;
            tr.appendChild(tdGenero);

            const tdArtista = document.createElement("td");
            tdArtista.textContent = musica.artista;
            tdArtista.title = musica.artista;
            tr.appendChild(tdArtista);

            const tdPlayer = document.createElement("td");
            const audio = document.createElement("audio");
            audio.id = i;
            audio.controls = true;
            audio.classList.add("audio-player")
            audio.style.width = "100%"
            const source = document.createElement("source");
            source.src = musica.filename;
            source.type = "audio/mpeg";
            audio.appendChild(source);
            audio.addEventListener("play", onPlayAudio)
            tdPlayer.appendChild(audio);
            tr.appendChild(tdPlayer);

            tbody.appendChild(tr);
        });
    }

    document.addEventListener("DOMContentLoaded", function() {
        fetchMusicas();
        document.getElementById("searchForm").addEventListener("submit", function(e) {
            e.preventDefault();
            const filtro = document.querySelector('input[name="filter"]').value;
            fetchMusicas(filtro);
        });
    });
</script>
</body>
</html>
