package com.reniec.personas.repository;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.reniec.personas.entity.Persona;

@Repository
public interface PersonaRepository extends CrudRepository<Persona, Long>{

	@Query("SELECT p FROM Persona p WHERE p.dni = :dni")
	Persona obtenerPersonaPorDni(@Param("dni") String dni);
}
