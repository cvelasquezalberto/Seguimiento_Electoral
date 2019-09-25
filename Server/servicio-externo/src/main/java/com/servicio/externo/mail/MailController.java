package com.servicio.externo.mail;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class MailController {

	@Autowired
	private MailService mailService; 
			
	@GetMapping(path = "/mail/registro-usuario/{usuario}/{correo}")
	public HashMap<String, Object> obtenerUsuarioPorCorreo(@PathVariable("usuario") String usuario, @PathVariable("correo") String correo) {
		mailService.enviarCorreoRegistroUsuario(correo, usuario);
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("respuesta", "OKK");
		return map;
	}
}
