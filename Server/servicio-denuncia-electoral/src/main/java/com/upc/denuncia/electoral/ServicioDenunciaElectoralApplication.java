package com.upc.denuncia.electoral;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.cloud.netflix.eureka.EnableEurekaClient;

import com.upc.denuncia.electoral.config.FileStorageProperties;

@EnableEurekaClient
@SpringBootApplication
@EnableConfigurationProperties({FileStorageProperties.class})
public class ServicioDenunciaElectoralApplication {

	public static void main(String[] args) {
		SpringApplication.run(ServicioDenunciaElectoralApplication.class, args);
	}

}
