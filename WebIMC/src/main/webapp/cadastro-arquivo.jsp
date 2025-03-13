<%@ page import="org.example.webimc.util.IMCCalculator" %>
<%@ page import="org.example.webimc.util.Usuario" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
<div class="container mt-3">
    <div style="display: flex; justify-content: space-between; width: 100%">
        <h2 class="mb-4">Upload de Arquivo MP3</h2>
        <div style="display: flex; gap: 10px;">
            <a href="index.jsp">
                <button type="button" class="btn btn-primary">
                    Home
                </button>
            </a>
            <a href="logoff-servlet">
                <button type="button" class="btn btn-primary">
                    Sair
                </button>
            </a>
        </div>
    </div>
    <form onsubmit="return validarEntrada()" action="upload-servlet" method="post" enctype="multipart/form-data">
        <div cclass="mb-1">
            <label for="musicFile" class="form-label">Escolha um arquivo MP3</label>
            <input type="file" class="form-control" id="musicFile" name="musicFile" accept="audio/mp3" onblur="validarArquivo()">
        </div>
        <div >
            <p id="arquivoMsg" style="visibility: hidden; color: red; margin: 0">
                Arquivo requerido
            </p>
        </div>
        <div class="mb-1">
            <label for="musicName" class="form-label">Nome da Música</label>
            <input type="text" class="form-control" id="musicName" name="musicName" placeholder="Digite o nome da música" onblur="validarInput('musicName', 'nomeMusicaMsg')">
        </div>
        <div  >
            <p id="nomeMusicaMsg" style="visibility: hidden; color: red; margin: 0">
                O nome da música pode conter apenas letras, números, espaços e underline
            </p>
        </div>
        <div class="mb-1">
            <label for="musicGenre" class="form-label">Estilo</label>
            <input type="text" class="form-control" id="musicGenre" name="musicGenre" placeholder="Digite o estilo musical" onblur="validarInput('musicGenre', 'estiloMsg')">
        </div>
        <div>
            <p id="estiloMsg" style="visibility: hidden; color: red; margin: 0">
                O estilo pode conter apenas letras, números, espaços e underline
            </p>
        </div>
        <div class="mb-1">
            <label for="artistName" class="form-label">Artista</label>
            <input type="text" class="form-control" id="artistName" name="artistName" placeholder="Digite o nome do artista" onblur="validarInput('artistName','artistaMsg')">
        </div>
        <div  class="mb-1">
            <p id="artistaMsg" style="visibility: hidden; color: red; margin: 0">
                O nome do artista pode conter apenas letras, números, espaços e underline
            </p>
        </div>
        <button type="submit" class="btn btn-primary">Enviar</button>
    </form>
</div>
</div>
<script>
    let regex = /^[a-zA-Z0-9_ ]+$/;

    function validarArquivo() {
        let fileSent = document.getElementById("musicFile")
        const msg = document.getElementById("arquivoMsg")
        if(fileSent.value){
            fileSent.classList.remove("is-invalid");
            msg.style.visibility = "hidden";
        } else {
            fileSent.classList.add("is-invalid");
            msg.style.visibility = "visible";
        }
    }

    function validarInput(inputId, msgId) {
        let input = document.getElementById(inputId);
        const msg = document.getElementById(msgId)
        if(!regex.test(input.value)){
            msg.style.visibility = "visible"
            input.classList.add("is-invalid")
        } else {
            if(msg.style.visibility === "visible"){
                msg.style.visibility = "hidden"
                input.classList.remove("is-invalid")
            }
        }
    }

    function validarEntrada() {
        let fileSent = document.getElementById("musicFile")
        let nomeMusica = document.getElementById("musicName").value;
        let artista = document.getElementById("artistName").value;
        let genre = document.getElementById("musicGenre").value;


        if(!fileSent.value){
            const msg = document.getElementById("arquivoMsg")
            msg.style.visibility = "visible";
            fileSent.classList.add("is-invalid");
            return false
        }

        if (!regex.test(nomeMusica)) {
            // alert("O nome da música pode conter apenas letras, números, espaços e underline.");
            return false;
        }

        if (!regex.test(artista)) {
            // alert("O nome do artista pode conter apenas letras, números, espaços e underline.");
            return false;
        }

        if (!regex.test(genre)) {
            // alert("O genero pode conter apenas letras, números, espaços e underline.");
            return false;
        }

        return true;
    }
</script>
</body>
</html>