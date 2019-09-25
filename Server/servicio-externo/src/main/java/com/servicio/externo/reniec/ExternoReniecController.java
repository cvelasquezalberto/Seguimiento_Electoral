package com.servicio.externo.reniec;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

import com.servicio.externo.dto.PersonaDTO;


@RestController
public class ExternoReniecController {
	
	@Autowired
	private ReniecPersonaClient ReniecPersonaClient; 
			
	@GetMapping(path = "/reniec/persona/{dni}")
	public PersonaDTO obtenerUsuarioPorCorreo(@PathVariable("dni") String dni) {
		return ReniecPersonaClient.validar(dni);
	}
}
