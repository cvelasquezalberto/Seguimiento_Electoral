package com.upc.auth.services;

import com.upc.auth.entidades.Usuario;

public interface IUsuarioService {
	public Usuario findByEmail(String email);
}
