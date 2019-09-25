package com.upc.denuncia.electoral.IntegrationTest;

import static org.mockito.BDDMockito.given;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import java.util.Arrays;
import java.util.List;

import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpUriRequest;
import org.apache.http.impl.client.HttpClientBuilder;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.test.web.servlet.MockMvc;

import com.upc.denuncia.electoral.entidades.PartidoPolitico;
import com.upc.denuncia.electoral.rest.PartidoPoliticoRestController;



@RunWith(SpringRunner.class)
@WebMvcTest(PartidoPoliticoRestController.class)
public class PartidoPoliticoApiTest {

	@Autowired
	private MockMvc mvc;

	@MockBean
	private PartidoPoliticoRestController partidoPoliticoRestController;
	
	@Test
	public void listarTest() throws Exception {
		PartidoPolitico partidoPolitico = new PartidoPolitico();
		partidoPolitico.setId(1L);
		partidoPolitico.setNombre("Nuevo Perú");
		
		List<PartidoPolitico> lisPartidoPoliticos = Arrays.asList(partidoPolitico);
		given(partidoPoliticoRestController.listar()).willReturn(lisPartidoPoliticos);

	        // when + then
	    this.mvc.perform(get("/api/partidos-politicos"))
	           .andExpect(status().isOk())
	           .andExpect(content().json("[{'id': 1,'nombre': 'Nuevo Perú','candidatos':null}]"));
	
	}
	
	/*@Test
	public void listarTest() {
		// Given
	    HttpUriRequest request = new HttpGet( "http://localhost:8080/api/partidos-politicos" );
	 
	    // Then
	    try {
	    	// When
		    HttpResponse response = HttpClientBuilder.create().build().execute(request);
			List<PartidoPolitico> listaPartidoPoliticos = RestUtil.retrieveResourceFromResponse( response,  (new ArrayList<PartidoPolitico>()).getClass());
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	    
	    
	    //assertThat( "eugenp", Matchers.is( resource.getLogin() ) );
	
	}
	*/
	
}
