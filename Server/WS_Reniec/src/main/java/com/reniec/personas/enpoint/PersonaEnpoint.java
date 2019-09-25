package com.reniec.personas.enpoint;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ws.server.endpoint.annotation.Endpoint;
import org.springframework.ws.server.endpoint.annotation.PayloadRoot;
import org.springframework.ws.server.endpoint.annotation.RequestPayload;
import org.springframework.ws.server.endpoint.annotation.ResponsePayload;

import com.reniec.personas.PersonaRequest;
import com.reniec.personas.PersonaResponse;
import com.reniec.personas.entity.Persona;
import com.reniec.personas.repository.PersonaRepository;

@Endpoint
public class PersonaEnpoint {
	
	@Autowired
	private PersonaRepository personaRepository;
	
	private static final String NAMESPACE_URI = "http://www.reniec.com/personas";

	@PayloadRoot(namespace = NAMESPACE_URI, localPart = "personaRequest")
	@ResponsePayload
	public PersonaResponse validar(@RequestPayload PersonaRequest request) {
		PersonaResponse personaResponse = new PersonaResponse();
		
		Persona personaEnt = personaRepository.obtenerPersonaPorDni(request.getDni()); 
		
		if(personaEnt == null) {
			personaResponse.setCodigo("R999");
		} else  {
			com.reniec.personas.Persona persona = new com.reniec.personas.Persona();
			persona.setNombres(personaEnt.getNombres());
			persona.setApellidos(personaEnt.getApellidos());
			persona.setDireccion(personaEnt.getDireccion());
			persona.setDni(personaEnt.getDni());
			personaResponse.setPersona(persona);
			personaResponse.setCodigo("R000");
		} 
		
		return  personaResponse;
	}
}
