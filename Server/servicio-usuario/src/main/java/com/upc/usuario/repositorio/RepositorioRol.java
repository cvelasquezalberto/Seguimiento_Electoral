package com.upc.usuario.repositorio;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import com.upc.usuario.entidades.Rol;

@Repository
public interface RepositorioRol extends CrudRepository<Rol, Long> {

}
