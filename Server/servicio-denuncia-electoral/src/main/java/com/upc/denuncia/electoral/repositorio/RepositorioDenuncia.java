package com.upc.denuncia.electoral.repositorio;

import java.util.List;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.upc.denuncia.electoral.entidades.Denuncia;

@Repository
public interface RepositorioDenuncia extends CrudRepository<Denuncia, Long> {
	@Query("Select d From Denuncia d Where d.idUsuario = :idUsuario ORDER BY d.fechaRegistro DESC")
	List<Denuncia> ObtenerDenunciasPorUsuario(@Param("idUsuario")int idUsuario);
	
	@Query("SELECT d "
			+ "FROM Denuncia d "
			+ "INNER JOIN Candidato c ON d.candidato.id = c.id "
			+ "WHERE c.partidoPolitico.id = :idPartidoPolitico OR 0 = :idPartidoPolitico "
			+ "ORDER BY d.fechaRegistro DESC")
	List<Denuncia> ListarDenuncias(@Param("idPartidoPolitico")Long idPartidoPolitico);
	
	@Query("SELECT d "
			+ "FROM Denuncia d "
			+ "WHERE d.idUsuario = :idUsuario "
			+ "ORDER BY d.totalSeguimiento DESC")
	List<Denuncia> ListarDenunciasSeguidasPorUsuario(@Param("idUsuario")int idUsuario);
	
	@Query("SELECT d "
			+ "FROM Denuncia d "
			+ "INNER JOIN Candidato c ON d.candidato.id = c.id "
			+ "WHERE c.partidoPolitico.id = :idPartidoPolitico OR 0 = :idPartidoPolitico "
			+ "ORDER BY d.totalSeguimiento DESC")
	List<Denuncia> ListarDenunciasTop(@Param("idPartidoPolitico")Long idPartidoPolitico);
}
