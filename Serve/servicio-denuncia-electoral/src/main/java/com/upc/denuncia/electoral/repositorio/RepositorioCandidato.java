package com.upc.denuncia.electoral.repositorio;

import java.util.List;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.upc.denuncia.electoral.entidades.Candidato;

@Repository
public interface RepositorioCandidato extends CrudRepository<Candidato, Long>{
	@Query("Select d From Candidato d "
			+ "INNER JOIN PartidoPolitico p ON d.partidoPolitico.id = p.id  "
			+ "WHERE d.partidoPolitico.id = :idpartido")
	List<Candidato> ListarCandidatoPorIdPartido(@Param("idpartido") Long idpartido);
}
