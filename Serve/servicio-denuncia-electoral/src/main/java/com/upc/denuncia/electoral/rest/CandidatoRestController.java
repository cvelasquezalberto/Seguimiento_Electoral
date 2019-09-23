package com.upc.denuncia.electoral.rest;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import com.upc.denuncia.electoral.core.ServicioCandidatoCore;
import com.upc.denuncia.electoral.entidades.Candidato;

@RestController
public class CandidatoRestController {
	
	@Autowired
	private ServicioCandidatoCore servicioCandidatoCore;

	@GetMapping("/candidatos")
	public List<Candidato> listar() {
		try{
			return servicioCandidatoCore.listar();
        }catch (Exception ex){
            throw new ResponseStatusException(HttpStatus.NOT_FOUND,"No se pudo encontrar",ex);
        }
	}
	
	@GetMapping("partidos-politicos/{id}/candidatos")
	public List<Candidato> ListarCandidatosIdPartido(@PathVariable("id") Long idPartidoPolítico) {
		try{
			return servicioCandidatoCore.ListarCandidatoPorIdPartido(idPartidoPolítico);
        }catch (Exception ex){
            throw new ResponseStatusException(HttpStatus.NOT_FOUND,"No se pudo encontrar",ex);
        }
	}
	
	@PostMapping("/candidatos")
	public Candidato registrar(@RequestBody Candidato candidato) {
		try{
			return servicioCandidatoCore.registrar(candidato);
        }catch (Exception ex){
            throw new ResponseStatusException(HttpStatus.NOT_FOUND,"No se pudo registrar",ex);
        }
	}
	
	@PutMapping("/candidatos/{id}")
	public Candidato actualizar(@PathVariable("id") Long id,@RequestBody Candidato candidato) {
		try{
			return servicioCandidatoCore.actualizar(id, candidato);
        }catch (Exception ex){
            throw new ResponseStatusException(HttpStatus.NOT_FOUND,"No se pudo registrar",ex);
        }
	}
}
