package com.upc.denuncia.electoral.core;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.upc.denuncia.electoral.entidades.Candidato;
import com.upc.denuncia.electoral.entidades.CargoPolitico;
import com.upc.denuncia.electoral.entidades.PartidoPolitico;
import com.upc.denuncia.electoral.repositorio.RepositorioCandidato;
import com.upc.denuncia.electoral.repositorio.RepositorioCargoPolitico;
import com.upc.denuncia.electoral.repositorio.RepositorioPartidoPolitico;

@Service
public class ServicioCandidatoCore {

	@Autowired
	private RepositorioCandidato repositorioCandidato;
	
	@Autowired
	private RepositorioPartidoPolitico repositorioPartidoPolitico;
	
	@Autowired
	private RepositorioCargoPolitico repositorioCargoPolitico;
	
	public List<Candidato> listar()
	{
		return (List<Candidato>)repositorioCandidato.findAll();
	}
	
	public List<Candidato> ListarCandidatoPorIdPartido(Long idPartido){
		return (List<Candidato>)repositorioCandidato.ListarCandidatoPorIdPartido(idPartido);
	}
	
	public Candidato registrar(Candidato candidato)
	{
		PartidoPolitico partidoPolitico = repositorioPartidoPolitico.findById(candidato.getIdPartidoPolitico()).get();
		CargoPolitico cargoPolitico = repositorioCargoPolitico.findById(candidato.getIdCargoPolitico()).get();
		
		candidato.setPartidoPolitico(partidoPolitico);
		candidato.setCargoPolitico(cargoPolitico);
		
		return repositorioCandidato.save(candidato);
	}
	
	public Candidato actualizar(Long id, Candidato candidato)
	{
		Candidato entCandidato = repositorioCandidato.findById(id).get();
		PartidoPolitico partidoPolitico = repositorioPartidoPolitico.findById(candidato.getIdPartidoPolitico()).get();
		CargoPolitico cargoPolitico = repositorioCargoPolitico.findById(candidato.getIdCargoPolitico()).get();
		
		entCandidato.setNombre(candidato.getNombre());
		entCandidato.setApellido(candidato.getApellido());
		entCandidato.setEstado(candidato.getEstado());
		entCandidato.setFoto(candidato.getFoto());
		
		entCandidato.setPartidoPolitico(partidoPolitico);
		entCandidato.setCargoPolitico(cargoPolitico);
		
		return repositorioCandidato.save(candidato);
	}
}
