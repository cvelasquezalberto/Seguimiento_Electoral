package com.upc.denuncia.electoral.repositorio;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import com.upc.denuncia.electoral.entidades.DocumentoAdjunto;

@Repository
public interface RepositorioDocumentoAdjunto extends CrudRepository<DocumentoAdjunto, Long> {
//	@Query("SELECT d FROM DocumentoAdjunto WHERE ")
//	List<DocumentoAdjunto> ObtenerAdjuntosPorDenuncia(@Param("idDenuncia") Long idDenuncia);
}
