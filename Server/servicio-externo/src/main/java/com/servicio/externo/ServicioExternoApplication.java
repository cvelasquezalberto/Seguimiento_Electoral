package com.servicio.externo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.netflix.eureka.EnableEurekaClient;

@EnableEurekaClient
@SpringBootApplication
public class ServicioExternoApplication {

	public static void main(String[] args) {
		SpringApplication.run(ServicioExternoApplication.class, args);
	}

}
