package com.upc.usuario.core;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.upc.usuario.entidades.Usuario;
import com.upc.usuario.repositorio.RepositorioUsuario;

@Service
public class ServicioUsuarioCore {
	
	@Autowired
	private RepositorioUsuario repositorioUsuario;
	
	public Usuario registrarUsuario(Usuario usuario) {
		
		return repositorioUsuario.save(usuario);
	}
	
	public Usuario buscarUsuarioPorCorreo(String correo) {
		return repositorioUsuario.findByCorreo(correo);
	}
}
