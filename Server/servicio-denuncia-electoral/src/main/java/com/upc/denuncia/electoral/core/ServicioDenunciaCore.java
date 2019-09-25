package com.upc.denuncia.electoral.core;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.rest.webmvc.ResourceNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.upc.denuncia.electoral.dto.DenunciaCandidatoDTO;
import com.upc.denuncia.electoral.dto.DenunciaPartialRequest;
import com.upc.denuncia.electoral.dto.EvidenciaDTO;
import com.upc.denuncia.electoral.dto.SeguimientoDenunciaRequest;
import com.upc.denuncia.electoral.dto.SeguimientoDenunciaResponse;
import com.upc.denuncia.electoral.entidades.Candidato;
import com.upc.denuncia.electoral.entidades.Denuncia;
import com.upc.denuncia.electoral.entidades.DocumentoAdjunto;
import com.upc.denuncia.electoral.entidades.Estado;
import com.upc.denuncia.electoral.entidades.SeguimientoDenuncia;
import com.upc.denuncia.electoral.repositorio.RepositorioCandidato;
import com.upc.denuncia.electoral.repositorio.RepositorioDenuncia;
import com.upc.denuncia.electoral.repositorio.RepositorioDocumentoAdjunto;
import com.upc.denuncia.electoral.repositorio.RepositorioEstado;
import com.upc.denuncia.electoral.repositorio.RepositorioSeguimientoDenuncia;
import com.upc.denuncia.electoral.services.FileStorageService;

@Service
public class ServicioDenunciaCore {
	
	@Autowired
	private RepositorioDenuncia repositorioDenuncia;
	@Autowired
	private RepositorioCandidato  repositorioCandidato;
	@Autowired
	private RepositorioEstado repositorioEstado;
	@Autowired
	private RepositorioDocumentoAdjunto repositorioDocumentoAdjunto;
	@Autowired
	private RepositorioSeguimientoDenuncia repositorioSeguimientoDenuncia;
	
	@Autowired
	private FileStorageService fileStorageService;
	
	public Denuncia registrarDenuncia(String titulo, 
									String descripcion, 
									Long idCandidato, 
									int idUsuario, 
									MultipartFile[] file1, 
									MultipartFile[] file2) {
		
		if(file1.length == 0 && file2.length == 0) {
			throw new  ResourceNotFoundException("Se debe adjuntar como mínimo una evidencia para la denuncia.");
		}
		
		Optional<Candidato> optCandidato = repositorioCandidato.findById(idCandidato);
		
		if(!optCandidato.isPresent()) {
			throw new  ResourceNotFoundException("El candidato con el id " + idCandidato + " no existe");
		}
		
		Denuncia denuncia = new Denuncia();
		denuncia.setTitulo(titulo);
		denuncia.setIdUsuario(idUsuario);
		denuncia.setDescripcion(descripcion);
		denuncia.setCandidato(optCandidato.get());
		denuncia.setEstado(repositorioEstado.findById(1L).get());	
		
		Denuncia denunciaEnt = repositorioDenuncia.save(denuncia);
		
		if(file1.length != 0) {
			DocumentoAdjunto documentoAdjunto = guardarDocumento(denunciaEnt, file1[0]);
			repositorioDocumentoAdjunto.save(documentoAdjunto);
		}
		
		if(file2.length != 0) {
			DocumentoAdjunto documentoAdjunto2 = guardarDocumento(denunciaEnt, file2[0]);
			repositorioDocumentoAdjunto.save(documentoAdjunto2);
		}
		
		return denunciaEnt;
	}
	
	private DocumentoAdjunto guardarDocumento(Denuncia denuncia, MultipartFile file) {
		String ruta = "evidencias/" + denuncia.getId() + "/";
		fileStorageService.storeFile(file, ruta);
		
		DocumentoAdjunto documentoAdjunto = new DocumentoAdjunto();
		documentoAdjunto.setDenuncia(denuncia);
		documentoAdjunto.setNombreArchivo(file.getOriginalFilename());
		documentoAdjunto.setTipoContenido(file.getContentType());
		documentoAdjunto.setGuid(UUID.randomUUID().toString());
		documentoAdjunto.setRuta(ruta);
			
		return documentoAdjunto;
	}
	
	public Denuncia registrar(Denuncia denuncia) {
		Optional<Candidato> optCandidato = repositorioCandidato.findById(denuncia.getIdCandidato());
		
		if(!optCandidato.isPresent()) {
			throw new  ResourceNotFoundException("El candidato con el id " + denuncia.getId() + " no existe");
		}
		
		denuncia.setCandidato(optCandidato.get());
		return repositorioDenuncia.save(denuncia);
	}
	
//	public Denuncia actualizar(Long idDenuncia, Denuncia denuncia) {
//		Optional<Denuncia> optDenuncia = repositorioDenuncia.findById(idDenuncia);
//		
//		if(!optDenuncia.isPresent()) {
//			throw new  ResourceNotFoundException("La denuncia con el id " + denuncia.getId() + " no existe");
//		}
//		
//		Optional<Candidato> optCandidato = repositorioCandidato.findById(denuncia.getIdCandidato());
//		
//		if(!optCandidato.isPresent()) {
//			throw new  ResourceNotFoundException("El candidato con el id " + denuncia.getId() + " no existe");
//		}
//		
//		denuncia.setCandidato(optCandidato.get());
//		return repositorioDenuncia.save(denuncia);
//	}
	
	public List<Denuncia> listar(){
		return (List<Denuncia>)repositorioDenuncia.findAll();
	}
	
	public List<Denuncia> ObtenerDenunciasPorUsuario(int idUsuario){
		return repositorioDenuncia.ObtenerDenunciasPorUsuario(idUsuario);
	}
	
	public Denuncia ObtenerDenunciaPorId(Long idDenuncia) {
		Optional<Denuncia> optDenuncia = repositorioDenuncia.findById(idDenuncia);
		
		if(!optDenuncia.isPresent()) {
			throw new  ResourceNotFoundException("La denuncia con el id " + idDenuncia + " no existe");
		}
		
		return optDenuncia.get();
	}
	
	public DenunciaCandidatoDTO ObtenerDetalleDenuncia(Long idDenuncia) {
		DenunciaCandidatoDTO denunciaCandidatoDTO = ObtenerDatosDenunciaCandidato(ObtenerDenunciaPorId(idDenuncia), 0);
		return denunciaCandidatoDTO;
	}
	
	private DenunciaCandidatoDTO ObtenerDatosDenunciaCandidato(Denuncia denuncia, int idUsuario) {
		DenunciaCandidatoDTO denunciaCandidatoDTO = new DenunciaCandidatoDTO();
		
		Candidato candidato = repositorioCandidato.findById(denuncia.getCandidato_id()).get();
		denunciaCandidatoDTO.id = denuncia.getId();
		denunciaCandidatoDTO.titulo = denuncia.getTitulo();
		denunciaCandidatoDTO.descripcion = denuncia.getDescripcion();
		denunciaCandidatoDTO.nombreCandidato = denuncia.getNombreCandidato();
		denunciaCandidatoDTO.fotoCandidato = "data:image/jpeg;base64," + fileStorageService.getImageBase64(candidato.getFoto());
		denunciaCandidatoDTO.cargoPolitico = candidato.getCargoPolitico().getNombre();
		denunciaCandidatoDTO.partidoPolitico = candidato.getPartidoPolitico().getNombre();
		denunciaCandidatoDTO.fotoPartidoPolitico = "data:image/jpeg;base64," + fileStorageService.getImageBase64(candidato.getPartidoPolitico().getFoto());
		denunciaCandidatoDTO.respuesta = denuncia.getRespuesta();
		denunciaCandidatoDTO.nombreEstado = denuncia.getEstado().getNombre();
		denunciaCandidatoDTO.idEstado = denuncia.getEstado().getId();
		denunciaCandidatoDTO.fecha = denuncia.getFecha();
		denunciaCandidatoDTO.evidencias = new ArrayList<EvidenciaDTO>();
		denunciaCandidatoDTO.totalSeguimiento = denuncia.getTotalSeguimiento();
		denunciaCandidatoDTO.siguiendo = ValidarSeguimientoDenunciaPorUsuario(denuncia.getId(), idUsuario);	
		
		if(denuncia.getDocumentosAdjuntos() != null) {
			denuncia.getDocumentosAdjuntos().forEach(x -> {
				denunciaCandidatoDTO.evidencias.add(new EvidenciaDTO(x.getId(), x.getNombreArchivo()));
			}) ;
		}
		
		return denunciaCandidatoDTO;
	}
	
	private boolean ValidarSeguimientoDenunciaPorUsuario(Long idDenuncia, int idUsuario)
	{
		SeguimientoDenuncia seguimientoDenuncia = repositorioSeguimientoDenuncia.obtenerSeguimientoPorDenuncia(idUsuario, idDenuncia);
		
		if(seguimientoDenuncia == null) {
			return false;
		}
		
		return seguimientoDenuncia.getEstado();
	}
	
	public List<DenunciaCandidatoDTO> ListarDenuncias(Long idPartidoPolitico, int idUsuario){
		List<DenunciaCandidatoDTO> denunciasDto = new ArrayList<>();
		List<Denuncia> denuncias = repositorioDenuncia.ListarDenuncias(idPartidoPolitico);
		
		denuncias.forEach(denuncia -> 
		{
			denunciasDto.add(ObtenerDatosDenunciaCandidato(denuncia, idUsuario));
		});
		
		return denunciasDto;
	}
	
	public List<Denuncia> ListarDenunciasSeguidasPorUsuario(int idUsuario){
		return repositorioDenuncia.ListarDenunciasSeguidasPorUsuario(idUsuario);
	}
	
	public List<DenunciaCandidatoDTO> ListarDenunciasTop(Long idPartidoPolitico , int idUsuario){
		List<DenunciaCandidatoDTO> denunciasDto = new ArrayList<>();
		List<Denuncia> denuncias = repositorioDenuncia.ListarDenunciasTop(idPartidoPolitico);
		
		denuncias.forEach(denuncia -> 
		{
			denunciasDto.add(ObtenerDatosDenunciaCandidato(denuncia, idUsuario));
		});
		
		return denunciasDto;
	}
	
	public DocumentoAdjunto ObtenerDocumentoPorId(Long idAdjunto) {
		Optional<DocumentoAdjunto> optDocumentoAdjunto = repositorioDocumentoAdjunto.findById(idAdjunto);
		
		if(!optDocumentoAdjunto.isPresent()) {
			throw new  ResourceNotFoundException("La evidencia con el id " + idAdjunto + " no existe");
		}
		
		return optDocumentoAdjunto.get();
	}
	
	public SeguimientoDenunciaResponse RegistrarSeguimiento(SeguimientoDenunciaRequest seguimientoDenunciaRequest) {
		SeguimientoDenunciaResponse seguimientoDenunciaResponse = new SeguimientoDenunciaResponse();
		Denuncia denuncia = repositorioDenuncia.findById(seguimientoDenunciaRequest.idDenuncia).get();
		SeguimientoDenuncia seguimientoDenuncia = repositorioSeguimientoDenuncia.obtenerSeguimientoPorDenuncia(seguimientoDenunciaRequest.idUsuario, 
																											   seguimientoDenunciaRequest.idDenuncia);		
		
		if(seguimientoDenuncia == null) {
			seguimientoDenuncia = new SeguimientoDenuncia();
			seguimientoDenuncia.setUsuarioId(seguimientoDenunciaRequest.idUsuario);
			seguimientoDenuncia.setEstado(true);
			seguimientoDenuncia.setDenuncia(denuncia);
		} else {
			seguimientoDenuncia.setEstado(!seguimientoDenuncia.getEstado());
			
		}
		
		repositorioSeguimientoDenuncia.save(seguimientoDenuncia);
		
		seguimientoDenunciaResponse.total = repositorioSeguimientoDenuncia.ObtenerTotalSeguimientoPorDenuncia(denuncia.getId());
		seguimientoDenunciaResponse.idDenuncia = denuncia.getId();
		
		denuncia.setTotalSeguimiento(seguimientoDenunciaResponse.total);
		repositorioDenuncia.save(denuncia);
		
		return seguimientoDenunciaResponse;		
	}
	
	public List<Estado> listarEstados(){
		return (List<Estado>)repositorioEstado.findAll();
	}
	
	public void actualizar(Long idDenuncia, DenunciaPartialRequest denunciaPartialRequest ) {
		try {
			Denuncia denuncia = repositorioDenuncia.findById(idDenuncia).get();
			Estado estado = repositorioEstado.findById(denunciaPartialRequest.idEstado).get();
			denuncia.setRespuesta(denunciaPartialRequest.respuesta);
			denuncia.setEstado(estado);
			
		} catch (Exception e) {
			throw new  ResourceNotFoundException("No se pudo actualizar la denuncia");
		}
	}
}
