package com.playmysongs.backend.config;


import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.io.File;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    // Caso opte por uma pasta externa (recomendado para arquivos dinâmicos):
    private final String UPLOAD_FOLDER = "src/main/resources/static/uploads/";

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // Converte o caminho da pasta para um caminho absoluto e garante a barra no final
        String absolutePath = new File(UPLOAD_FOLDER).getAbsolutePath() + File.separator;
        registry.addResourceHandler("/uploads/**")
                .addResourceLocations("file:" + absolutePath);
    }
}
