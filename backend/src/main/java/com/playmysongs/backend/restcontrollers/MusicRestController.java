package com.playmysongs.backend.restcontrollers;

import com.playmysongs.backend.entities.Erro;
import com.playmysongs.backend.entities.Musica;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping(value = "apis")
@CrossOrigin(origins = "http://localhost:8081")
public class MusicRestController {
    private final String UPLOAD_FOLDER = "src/main/resources/static/uploads/";

    @Autowired
    private HttpServletRequest request;

    private String splitJoin(String str){
        return String.join(" ", str.trim().split("_")).trim();
    }

    @PostMapping(value="music-upload")
    public ResponseEntity<Object> musicUpload(@RequestParam("titulo") String titulo,
                                              @RequestParam("artista") String artista,
                                              @RequestParam("estilo") String estilo,
                                              @RequestParam("file") MultipartFile file){
        String fileName="";
        try {
            File uploadFolder = new File(UPLOAD_FOLDER);
            if (!uploadFolder.exists()) uploadFolder.mkdir();
            fileName = splitJoin(titulo) + "_" + splitJoin(estilo) + "_" + splitJoin(artista) + ".mp3";
            file.transferTo(new File(uploadFolder.getAbsolutePath() + File.separator + fileName));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(new Erro("Erro ao armazenar o arquivo." + e.getMessage()));
        }
        Musica musica=new Musica(titulo,artista,estilo,fileName);
        return ResponseEntity.ok( musica);
    }

    @GetMapping(value="musics")
    public ResponseEntity<Object> findMusics(@RequestParam(value = "chave", required = false) String chave){
        System.out.println(chave);
        File files=new File(UPLOAD_FOLDER);
        List<Musica> musicaList=new ArrayList<>();
        String[] arquivos = files.list();
        for(String arq : arquivos)
        {
            String[] fileNameSplt = arq.split("_");
            if(chave != null){
                if (arq.toUpperCase().contains(chave.toUpperCase())) {
                    musicaList.add(new Musica(fileNameSplt[0],fileNameSplt[2].split(".mp3")[0],fileNameSplt[1],getHostStatic()+"/"+arq));
                }
            } else {
                musicaList.add(new Musica(fileNameSplt[0],fileNameSplt[2].split(".mp3")[0],fileNameSplt[1],getHostStatic()+arq));
            }
        }
        if (musicaList.isEmpty())
            return ResponseEntity.badRequest().body(new Erro("Nenuma música encontrada"));
        else
            return ResponseEntity.ok(musicaList);
    }   
    public String getHostStatic() {
        return "http://" + request.getServerName() + ":" + request.getServerPort() + "/uploads/";
    }
}
