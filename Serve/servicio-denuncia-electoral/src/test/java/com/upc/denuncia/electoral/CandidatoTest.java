package com.upc.denuncia.electoral;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.ListIterator;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

import com.upc.denuncia.electoral.entidades.Candidato;
import com.upc.denuncia.electoral.entidades.CargoPolitico;
import com.upc.denuncia.electoral.entidades.Denuncia;
import com.upc.denuncia.electoral.entidades.PartidoPolitico;
import com.upc.denuncia.electoral.repositorio.RepositorioCandidato;
import com.upc.denuncia.electoral.repositorio.RepositorioCargoPolitico;
import com.upc.denuncia.electoral.repositorio.RepositorioPartidoPolitico;

import junit.framework.Assert;

@RunWith(SpringRunner.class)
@SpringBootTest
public class CandidatoTest {
	@Autowired
	private RepositorioCandidato repositorioCandidato;
	
	@Autowired
	private RepositorioCargoPolitico repositorioCargoPolitico;
	
	@Autowired
	private RepositorioPartidoPolitico repositorioPartidoPolitico;
	
	@Test
	public void registrarCandidatoTest() {
		CargoPolitico cargoPolitico = repositorioCargoPolitico.findById(1L).get();
		PartidoPolitico partidoPolitico = repositorioPartidoPolitico.findById(1L).get();
		
		Candidato candidato = new Candidato();
		candidato.setCargoPolitico(cargoPolitico);
		candidato.setPartidoPolitico(partidoPolitico);
		candidato.setNombre("Keiko");
		candidato.setApellido("Fujimori");
		candidato.setFechaRegistro(new Date());
		candidato.setFoto("C:\\docmentos");
		candidato.setIdUsuario(1);
		candidato.setEstado(1);
		candidato.setDenuncias(new ArrayList<Denuncia>());
		
		Candidato ent = repositorioCandidato.save(candidato);
		
		Assert.assertNotNull(ent);
	}
}
