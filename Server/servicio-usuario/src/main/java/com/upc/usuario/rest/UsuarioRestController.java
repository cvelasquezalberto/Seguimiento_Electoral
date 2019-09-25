package com.upc.usuario.rest;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.rest.webmvc.ResourceNotFoundException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.server.ResponseStatusException;

import com.upc.usuario.core.ServicioUsuarioCore;
import com.upc.usuario.entidades.Usuario;

@RestController
//@RequestMapping("/api")
public class UsuarioRestController {
	
	@Autowired
	private ServicioUsuarioCore servicioUsuarioCore;
	
	@GetMapping(path = "/usuarios/search/{correo}")
	public Usuario obtenerUsuarioPorCorreo(@RequestParam("correo") String correo) {
		return servicioUsuarioCore.buscarUsuarioPorCorreo(correo);
	}
	
	@GetMapping(path = "/usuarios/{correo}/foto")
	public Usuario ObtenerFoto(@PathVariable("correo") String correo) {
		return servicioUsuarioCore.obtenerUsuarioPorCorreo(correo);
	}
	
	@RequestMapping(path =  "/usuarios/v2", consumes = { "multipart/form-data" } )
	//@PostMapping("/usuarios/v2")
	public ResponseEntity<Usuario> Registrar( @RequestParam(value = "nombre") String nombre,
											  @RequestParam(value = "apellido") String apellido,
											  @RequestParam(value = "dni") String dni,
											  @RequestParam(value = "correo") String correo,
											  @RequestParam(value = "contrasena") String contrasena,
											  @RequestParam(value = "file1") MultipartFile[] file1
											) 
	{
		try {
			Usuario usuario = new Usuario(nombre, apellido,dni, correo);
			return ResponseEntity.ok(servicioUsuarioCore.registrar(usuario,contrasena, file1 ));
		} 
		catch (ResponseStatusException e) {
			throw new ResponseStatusException(HttpStatus.BAD_REQUEST,e.getMessage());
		}
		catch (Exception e) {
			throw new ResponseStatusException(HttpStatus.BAD_REQUEST,"No se pudo registrar",e);
		}
	}
	
}
