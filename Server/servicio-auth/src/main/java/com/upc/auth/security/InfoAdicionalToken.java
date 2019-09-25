package com.upc.auth.security;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Base64;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.oauth2.common.DefaultOAuth2AccessToken;
import org.springframework.security.oauth2.common.OAuth2AccessToken;
import org.springframework.security.oauth2.provider.OAuth2Authentication;
import org.springframework.security.oauth2.provider.token.TokenEnhancer;
import org.springframework.stereotype.Component;

import com.upc.auth.entidades.Usuario;
import com.upc.auth.services.IUsuarioService;

@Component
public class InfoAdicionalToken implements TokenEnhancer {
	@Autowired
	private IUsuarioService usuarioService;
	
	@Value("${file.upload-dir}")
	private String rutaStorage;
	@Override
	public OAuth2AccessToken enhance(OAuth2AccessToken accessToken, OAuth2Authentication authentication) {
		Map<String, Object> info = new HashMap<>();
		
		Usuario usuario = usuarioService.findByEmail(authentication.getName());
		info.put("id", usuario.getIdUsuario());
		info.put("nombre", usuario.getNombre());
		info.put("apellido", usuario.getApellido());
		info.put("correo", usuario.getCorreo());
		
		((DefaultOAuth2AccessToken)accessToken).setAdditionalInformation(info);
		
		return accessToken;
	}
	
	private String obtenerFoto(String rutaFoto) {
		String imageDataString = "";
    	Path filePath = Paths.get(rutaStorage).resolve(rutaFoto).normalize();
    	File file = filePath.toFile();
    	
    	 
        try {            
            FileInputStream imageInFile = new FileInputStream(file);
            byte imageData[] = new byte[(int) file.length()];
            imageInFile.read(imageData);
            imageDataString = encodeImage(imageData);
            imageInFile.close();
        } catch (FileNotFoundException e) {
            System.out.println("Image not found" + e);
        } catch (IOException ioe) {
            System.out.println("Exception while reading the Image " + ioe);
        }
        
        return "data:image/jpeg;base64," + imageDataString;
	}

	public static String encodeImage(byte[] imageByteArray) {
        return Base64.getEncoder().encodeToString(imageByteArray);
    }
}
