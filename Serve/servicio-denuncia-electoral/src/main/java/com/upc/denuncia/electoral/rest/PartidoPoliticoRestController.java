package com.upc.denuncia.electoral.rest;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import com.upc.denuncia.electoral.entidades.PartidoPolitico;
import com.upc.denuncia.electoral.repositorio.RepositorioPartidoPolitico;

@RestController
@RequestMapping
public class PartidoPoliticoRestController {

	@Autowired
	private RepositorioPartidoPolitico repositorioPartidoPolitico;

	@GetMapping("/partidos-politicos")
	public List<PartidoPolitico> listar() {
		return (List<PartidoPolitico>)repositorioPartidoPolitico.findAll();
	}
	
	@PostMapping("/partidos-politicos")
	public ResponseEntity<PartidoPolitico> registrar(@RequestBody PartidoPolitico partidoPolitico) {
		try{
			return ResponseEntity.ok(repositorioPartidoPolitico.save(partidoPolitico));
        }catch (Exception ex){
            throw new ResponseStatusException(HttpStatus.NOT_FOUND,"No se pudo registrar",ex);
        }
	}
}
