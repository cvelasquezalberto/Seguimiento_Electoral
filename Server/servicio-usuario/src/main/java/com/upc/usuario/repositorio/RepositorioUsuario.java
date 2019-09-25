package com.upc.usuario.repositorio;

import java.util.List;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;
import org.springframework.data.rest.core.annotation.RestResource;

import com.upc.usuario.entidades.Usuario;

@RepositoryRestResource(path="usuarios")
public interface RepositorioUsuario extends PagingAndSortingRepository<Usuario, Long>{
	
	@RestResource(path="email")
	public Usuario findByCorreo(@Param("correo") String correo);
	
	@Query("SELECT u FROM Usuario u WHERE u.dni =:dni OR u.correo = :correo ")
	public List<Usuario> ObtenerUsuarioPorDniOCorreo(@Param("dni") String dni, @Param("correo") String correo);
}
