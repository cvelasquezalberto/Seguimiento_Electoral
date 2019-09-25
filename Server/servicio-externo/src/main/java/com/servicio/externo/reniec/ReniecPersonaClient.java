package com.servicio.externo.reniec;

import org.springframework.http.HttpStatus;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.ws.client.core.support.WebServiceGatewaySupport;
import org.springframework.ws.soap.client.core.SoapActionCallback;

import com.servicio.externo.dto.PersonaDTO;
import com.servicio.externo.reniec.generate.PersonaRequest;
import com.servicio.externo.reniec.generate.PersonaResponse;


public class ReniecPersonaClient extends WebServiceGatewaySupport {
	
	public PersonaDTO validar(String documento) {
		PersonaDTO oPersonaDTO = new PersonaDTO();
		
		PersonaRequest personaRequest = new PersonaRequest();
		personaRequest.setDni(documento);
		
		PersonaResponse response = (PersonaResponse) getWebServiceTemplate()
				.marshalSendAndReceive("http://localhost:8555/ws/persona", personaRequest,
						new SoapActionCallback(
								"http://www.reniec.com/persona"));
			
		if(response.getCodigo().equals("R999")) {
			throw new ResponseStatusException(HttpStatus.NOT_FOUND, "No se pudo encontraron datos.");
		}
		
		oPersonaDTO.nombres = response.getPersona().getNombres();
		oPersonaDTO.apellidos = response.getPersona().getApellidos();
		oPersonaDTO.direccion = response.getPersona().getDireccion();
		oPersonaDTO.dni = response.getPersona().getDni();
		
		return oPersonaDTO;
	}
}
