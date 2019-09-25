package com.servicio.externo.reniec;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.oxm.jaxb.Jaxb2Marshaller;
//
@Configuration
public class PersonaServiceConfig {
	@Bean
	public Jaxb2Marshaller marshaller() {
		Jaxb2Marshaller marshaller = new Jaxb2Marshaller();
		// this package must match the package in the <generatePackage> specified in
		// pom.xml
		marshaller.setContextPath("com.servicio.externo.reniec.generate");
		return marshaller;
	}

	@Bean
	public ReniecPersonaClient reniecPersonaClient(Jaxb2Marshaller marshaller) {
		ReniecPersonaClient client = new ReniecPersonaClient();
		client.setDefaultUri("http://localhost:8555/ws/");
		client.setMarshaller(marshaller);
		client.setUnmarshaller(marshaller);
		return client;
	}
}
