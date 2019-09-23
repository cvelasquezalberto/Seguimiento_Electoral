package com.upc.usuario.repositorio;

import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;
import org.springframework.data.rest.core.annotation.RestResource;

import com.upc.usuario.entidades.Usuario;

@RepositoryRestResource(path="usuarios")
public interface RepositorioUsuario extends PagingAndSortingRepository<Usuario, Long>{
	
	@RestResource(path="email")
	public Usuario findByCorreo(@Param("correo") String correo);
}
