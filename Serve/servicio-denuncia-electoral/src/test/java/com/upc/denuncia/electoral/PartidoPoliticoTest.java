package com.upc.denuncia.electoral;

import java.util.Calendar;
import java.util.Date;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

import com.upc.denuncia.electoral.entidades.PartidoPolitico;
import com.upc.denuncia.electoral.repositorio.RepositorioPartidoPolitico;

import junit.framework.Assert;

@RunWith(SpringRunner.class)
@SpringBootTest
public class PartidoPoliticoTest {
	
	@Autowired
	private RepositorioPartidoPolitico repositorioPartidoPolitico;
	
	@Test
	public void registrarPartidoPoliticoTest() {
		PartidoPolitico partidoPolitico = new PartidoPolitico();
		partidoPolitico.setNombre("Fuerza Popular");
		partidoPolitico.setDescripcion("Partido político fundado");
		partidoPolitico.setFechaRegistro(new Date());
		partidoPolitico.setFoto("C:\\docmentos");
		partidoPolitico.setEstado(1);
		
		PartidoPolitico ent = repositorioPartidoPolitico.save(partidoPolitico);
		
		Assert.assertNotNull(ent);
	}
}
