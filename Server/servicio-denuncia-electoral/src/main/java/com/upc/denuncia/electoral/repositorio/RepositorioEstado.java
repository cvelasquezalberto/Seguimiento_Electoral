package com.upc.denuncia.electoral.repositorio;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import com.upc.denuncia.electoral.entidades.Estado;

@Repository
public interface RepositorioEstado extends CrudRepository<Estado, Long> {

}
