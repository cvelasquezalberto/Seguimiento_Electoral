package com.upc.usuario.core;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.Base64;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.jboss.jandex.TypeTarget.Usage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.server.ResponseStatusException;

import com.upc.usuario.entidades.Rol;
import com.upc.usuario.entidades.Usuario;
import com.upc.usuario.repositorio.RepositorioRol;
import com.upc.usuario.repositorio.RepositorioUsuario;

@Service
public class ServicioUsuarioCore {
	
	@Autowired
	private BCryptPasswordEncoder passwordEncoder;
	
	@Autowired
	private RestTemplate restTemplate;
	
	@Autowired
	private RepositorioUsuario repositorioUsuario;
	
	@Autowired
	private RepositorioRol repositorioRol;
	
	@Value("${file.upload-dir}")
	private String rutaStorage;
	
	public Usuario registrarUsuario(Usuario usuario) {
		
		return repositorioUsuario.save(usuario);
	}
	
	public Usuario buscarUsuarioPorCorreo(String correo) {
		return repositorioUsuario.findByCorreo(correo);
	}
	
	public Usuario obtenerUsuarioPorCorreo(String correo) {
		Usuario usuario = repositorioUsuario.findByCorreo(correo);
		usuario.setFoto(obtenerFoto(usuario.getFoto()));
		return usuario;
	} 
	
	public Usuario registrar(Usuario usuario, String contrasena, MultipartFile[] file1) {
		
		List<Usuario> listaUsuario = repositorioUsuario.ObtenerUsuarioPorDniOCorreo(usuario.getDni(), usuario.getCorreo());
		
		if(listaUsuario.size() != 0) {
			if(listaUsuario.stream().filter(usu -> usu.getDni().equals(usuario.getDni())).findAny() != null) {
				throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "El dni ya se encuentra registrado");
			}
			
			if(listaUsuario.stream().filter(usu -> usu.getDni().equals(usuario.getDni())).findAny() != null) {
				throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "El correo ya se encuentra registrado");
			}
		}
		
		List<Rol> listaRol = new ArrayList<>();
		listaRol.add(repositorioRol.findById(1L).get());
		usuario.setContrasena(passwordEncoder.encode(contrasena));	
		usuario.setActivo(true);
		usuario.setListaRol(listaRol);
		
		if(file1.length != 0) {
			usuario.setFoto(guardarFoto(usuario.getDni(), file1[0]));
		}
		else
		{
			usuario.setFoto("usuario/user.jpeg");
		}
		
		Usuario usuarioEnt = repositorioUsuario.save(usuario);
		enviarCorreo(usuarioEnt);
	   
	   return usuarioEnt;
	}
	
	private void enviarCorreo(Usuario usuario) {
		Map<String, String> pathVariables = new HashMap<String, String>();
		pathVariables.put("usuario",usuario.getNombresCompletos());
		pathVariables.put("correo",usuario.getCorreo());
		
		try {
			ResponseEntity<String> response = restTemplate.getForEntity("http://servicio-externo/mail/registro-usuario/{usuario}/{correo}", String.class, pathVariables);
		} catch (Exception e) {
			
		}
	}

	private String guardarFoto(String dni, MultipartFile file ) {
		
		String directorio = "usuario/" + dni + "/";
		String fileName = StringUtils.cleanPath(file.getOriginalFilename());
		String rutaFinal = directorio.concat(fileName);

		if(fileName.contains("..")) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "La foto no tiene el formato correcto");
        }
		
    	try {
			Files.createDirectories(Paths.get(rutaStorage).resolve(directorio).normalize());
			Path targetLocation = Paths.get(rutaStorage).resolve(rutaFinal);
	        Files.copy(file.getInputStream(), targetLocation, StandardCopyOption.REPLACE_EXISTING);
		} catch (IOException e) {
			throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Error al guardar las imagenes");
		}
    	
        return rutaFinal;
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
