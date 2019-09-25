package com.upc.denuncia.electoral.repositorio;

import org.springframework.data.repository.CrudRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

import com.upc.denuncia.electoral.entidades.CargoPolitico;

@RepositoryRestResource(path="cargos-politicos")
public interface RepositorioCargoPolitico extends CrudRepository<CargoPolitico, Long> {

}
