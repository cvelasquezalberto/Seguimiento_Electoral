package com.upc.denuncia.electoral.rest;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.data.rest.webmvc.ResourceNotFoundException;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.server.ResponseStatusException;

import com.upc.denuncia.electoral.core.ServicioDenunciaCore;
import com.upc.denuncia.electoral.dto.DenunciaCandidatoDTO;
import com.upc.denuncia.electoral.dto.DenunciaPartialRequest;
import com.upc.denuncia.electoral.dto.SeguimientoDenunciaRequest;
import com.upc.denuncia.electoral.dto.SeguimientoDenunciaResponse;
import com.upc.denuncia.electoral.entidades.Denuncia;
import com.upc.denuncia.electoral.entidades.DocumentoAdjunto;
import com.upc.denuncia.electoral.entidades.Estado;
import com.upc.denuncia.electoral.services.FileStorageService;

@RestController
@RequestMapping
public class DenunciaRestController {
	@Autowired
	private ServicioDenunciaCore servicioDenunciaCore;
	
	@Autowired
	private FileStorageService fileStorageService;
	
	@GetMapping("/denuncias/{id}")
	public ResponseEntity<Denuncia> ObtenerPorId(@PathVariable("id")Long idDenuncia) {
		return ResponseEntity.ok().body(servicioDenunciaCore.ObtenerDenunciaPorId(idDenuncia));
	}
	
	@GetMapping("/partidos-politicos/{id}/denuncias")
	public ResponseEntity<List<DenunciaCandidatoDTO>> ListarDenuncias(@PathVariable("id")Long idPartidoPolitico, @RequestParam("idUsuario") int idUsuario) {
		return ResponseEntity.ok().body(servicioDenunciaCore.ListarDenuncias(idPartidoPolitico, idUsuario));
	}
	
	@GetMapping("/partidos-politicos/{id}/denuncias/top")
	public ResponseEntity<List<DenunciaCandidatoDTO>> ListarDenunciasTop(@PathVariable("id")Long idPartidoPolitico, @RequestParam("idUsuario") int idUsuario) {
		return ResponseEntity.ok().body(servicioDenunciaCore.ListarDenunciasTop(idPartidoPolitico, idUsuario));
	}
	
	@GetMapping("/denuncias/usuarios/{id}/seguimiento")
	public ResponseEntity<List<Denuncia>> ListarDenunciasSeguidasPorUsuario(@PathVariable("id")int idUsuario) {
		return ResponseEntity.ok().body(servicioDenunciaCore.ListarDenunciasSeguidasPorUsuario(idUsuario));
	}
	
	@GetMapping("/denuncias/{id}/detalle")
	public ResponseEntity<DenunciaCandidatoDTO> ObtenerDetalle(@PathVariable("id")Long idDenuncia) {
		return ResponseEntity.ok().body(servicioDenunciaCore.ObtenerDetalleDenuncia(idDenuncia));
	}
	
	@PostMapping("/denuncias")
	public ResponseEntity<Denuncia> Registrar(@RequestBody Denuncia denuncia) {
		return ResponseEntity.ok(servicioDenunciaCore.registrar(denuncia));
	}
	
	@PostMapping("/denuncias/v2")
	public ResponseEntity<Denuncia> RegistrarDenuncia(@RequestParam(value = "titulo") String titulo,
													  @RequestParam(value = "descripcion") String descripcion,
													  @RequestParam(value = "idCandidato") Long idCandidato,
													  @RequestParam(value = "idUsuario") int idUsuario,
													  @RequestParam(value = "file1") MultipartFile[] file1,
													  @RequestParam(value = "file2") MultipartFile[] file2
													  ) 
	{
		try {
			
			
			return ResponseEntity.ok(servicioDenunciaCore.registrarDenuncia(titulo, descripcion, idCandidato, idUsuario,file1, file2 ));
		} 
		catch (ResourceNotFoundException e) {
			throw new ResponseStatusException(HttpStatus.BAD_REQUEST,e.getMessage());
		}
		catch (Exception e) {
			throw new ResponseStatusException(HttpStatus.BAD_REQUEST,"No se pudo registrar",e);
		}
	}
	
	@PostMapping("/denuncias/seguimiento")
	public ResponseEntity<SeguimientoDenunciaResponse> RegistrarSeguimiento(@RequestBody SeguimientoDenunciaRequest seguimientoDenunciaRequest) {
		
		try {
			return ResponseEntity.ok(servicioDenunciaCore.RegistrarSeguimiento(seguimientoDenunciaRequest));
		} catch (Exception e) {
			throw new ResponseStatusException(HttpStatus.BAD_REQUEST,"No se pudo registrar",e);
		}
	}
	
	@GetMapping("/denuncias/evidencias/{id}")
    public ResponseEntity<Resource> downloadFile(@PathVariable(name = "id") Long idAdjunto) {
		
		DocumentoAdjunto documentoAdjunto = servicioDenunciaCore.ObtenerDocumentoPorId(idAdjunto);
        Resource resource = fileStorageService.loadFileAsResource(documentoAdjunto.ObtenerRutaArchivo());
        return ResponseEntity.ok()
                .contentType(MediaType.parseMediaType(documentoAdjunto.getTipoContenido()))
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + resource.getFilename() + "\"")
                .body(resource);
    }
	
	@GetMapping("/denuncias/{idUsuario}/mis-denuncias")
	public ResponseEntity<List<Denuncia>> ObtenerDenunciasPorUsuario(@PathVariable(value = "idUsuario") int idUsuario) {
		try{
			List<Denuncia> misDenuncias = servicioDenunciaCore.ObtenerDenunciasPorUsuario(idUsuario);
			return ResponseEntity.ok().body(misDenuncias);
        }catch (Exception ex){
            throw new ResponseStatusException(HttpStatus.NOT_FOUND,"No se pudo registrar",ex);
        }
	}
	 
	@PutMapping("/denuncias/{id}")
	public void ActualizarDenuncia(@PathVariable(value = "id") Long idDenuncia, @RequestBody DenunciaPartialRequest denunciaPartialRequest) {
		servicioDenunciaCore.actualizar(idDenuncia, denunciaPartialRequest);
	}
	
	@GetMapping("/denuncias/estados")
	public ResponseEntity<List<Estado>> listarEstados() {
		return ResponseEntity.ok().body(servicioDenunciaCore.listarEstados());
	}
}
