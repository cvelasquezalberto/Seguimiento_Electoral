package com.upc.usuario.rest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import com.upc.usuario.core.ServicioUsuarioCore;
import com.upc.usuario.entidades.Usuario;

@RestController
@RequestMapping("/api")
public class UsuarioRestController {
	
	@Autowired
	private ServicioUsuarioCore servicioUsuarioCore;
	
	@GetMapping(path = "/usuarios/search/{correo}")
	public Usuario obtenerUsuarioPorCorreo(@RequestParam("correo") String correo) {
		return servicioUsuarioCore.buscarUsuarioPorCorreo(correo);
	}
	
	@PostMapping("/usuarios")
	public ResponseEntity<Usuario> registrarUsuario(@RequestBody Usuario usuario) {
		try{
			return ResponseEntity.ok(servicioUsuarioCore.registrarUsuario(usuario));
        }catch (Exception ex){
            throw new ResponseStatusException(HttpStatus.NOT_FOUND,"No se pudo registrar",ex);
        }
	}
}
