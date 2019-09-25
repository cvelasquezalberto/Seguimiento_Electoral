package com.upc.denuncia.electoral.dto;

import java.io.Serializable;

import org.springframework.web.multipart.MultipartFile;

public class DenunciaDTO implements Serializable {

	private String titulo;
	private String descripcion;
	private Long idCandidato;
	private Long idUsuario;
	private MultipartFile file1;
	private MultipartFile file2;
	public String getTitulo() {
		return titulo;
	}
	public void setTitulo(String titulo) {
		this.titulo = titulo;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public Long getIdCandidato() {
		return idCandidato;
	}
	public void setIdCandidato(Long idCandidato) {
		this.idCandidato = idCandidato;
	}
	public Long getIdUsuario() {
		return idUsuario;
	}
	public void setIdUsuario(Long idUsuario) {
		this.idUsuario = idUsuario;
	}
	public MultipartFile getFile1() {
		return file1;
	}
	public void setFile1(MultipartFile file1) {
		this.file1 = file1;
	}
	public MultipartFile getFile2() {
		return file2;
	}
	public void setFile2(MultipartFile file2) {
		this.file2 = file2;
	}
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -2419280023008517436L;
}
