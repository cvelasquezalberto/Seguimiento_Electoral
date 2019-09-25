package com.reniec.personas.entity;

import java.io.Serializable;

public class PersonaRequest implements Serializable {

	private String dni;
	private String fechaEmision;
	
	public String getDni() {
		return dni;
	}
	public void setDni(String dni) {
		this.dni = dni;
	}
	public String getFechaEmision() {
		return fechaEmision;
	}
	public void setFechaEmision(String fechaEmision) {
		this.fechaEmision = fechaEmision;
	}
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -1339793186909478697L;
}
