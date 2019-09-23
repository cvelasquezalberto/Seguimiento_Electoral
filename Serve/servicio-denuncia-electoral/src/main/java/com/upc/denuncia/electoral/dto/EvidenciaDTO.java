package com.upc.denuncia.electoral.dto;

import java.io.Serializable;

public class EvidenciaDTO implements Serializable {
	private Long id;
	private String nombreArchivo;
	
	public EvidenciaDTO(Long id, String nombreArchivo) {
		super();
		this.id = id;
		this.nombreArchivo = nombreArchivo;
	}
	
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getNombreArchivo() {
		return nombreArchivo;
	}

	public void setNombreArchivo(String nombreArchivo) {
		this.nombreArchivo = nombreArchivo;
	}
	
	private static final long serialVersionUID = 5781650240134852670L;

}
