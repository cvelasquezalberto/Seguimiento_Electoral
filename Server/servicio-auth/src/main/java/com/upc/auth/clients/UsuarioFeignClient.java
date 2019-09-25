package com.upc.auth.clients;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.upc.auth.entidades.Usuario;

@FeignClient(name="servicio-usuario")
public interface UsuarioFeignClient {

	@GetMapping("/usuarios/search/email")
	public Usuario ObtenerUsuarioPorCorreo(@RequestParam String correo);
}
