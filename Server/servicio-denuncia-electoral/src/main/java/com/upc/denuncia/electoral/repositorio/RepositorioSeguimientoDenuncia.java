package com.upc.denuncia.electoral.repositorio;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.upc.denuncia.electoral.entidades.SeguimientoDenuncia;

@Repository
public interface RepositorioSeguimientoDenuncia extends CrudRepository<SeguimientoDenuncia, Long>{

	@Query("SELECT s FROM SeguimientoDenuncia s WHERE s.usuarioId = :idUsuario AND s.denuncia.id = :idDenuncia")
	SeguimientoDenuncia obtenerSeguimientoPorDenuncia(@Param("idUsuario") int idUsuario, @Param("idDenuncia") Long idDenuncia);
	
	@Query("SELECT COUNT(s.id) FROM SeguimientoDenuncia s WHERE s.denuncia.id = :idDenuncia AND s.estado = true")
	Long ObtenerTotalSeguimientoPorDenuncia(@Param("idDenuncia") Long idDenuncia);
}
