package com.upc.auth.services;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.upc.auth.clients.UsuarioFeignClient;
import com.upc.auth.entidades.Usuario;

@Service
public class UsuarioService implements IUsuarioService, UserDetailsService{
	
	@Autowired(required=true)
	private UsuarioFeignClient client;
	
	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
		Usuario usuario = client.ObtenerUsuarioPorCorreo(username);
		
		if(usuario == null) {
			throw new UsernameNotFoundException("Usuario no válido");
		}
		
		List<GrantedAuthority> authorities = usuario.getListaRol()
								        .stream()
								        .map(role -> new SimpleGrantedAuthority(role.getNombre()))
								        .collect(Collectors.toList());
		
		return new User(usuario.getCorreo(), usuario.getContrasena(), true, true, true, true, authorities);
	}

	@Override
	public Usuario findByEmail(String email) {
		return client.ObtenerUsuarioPorCorreo(email);
	}
}
