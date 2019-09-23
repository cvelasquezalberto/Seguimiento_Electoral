package com.upc.denuncia.electoral.entidades;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.Table;

import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import com.fasterxml.jackson.annotation.JsonIgnore;

@Entity
@Table(name = "PartidoPolitico")
public class PartidoPolitico implements Serializable {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;
	private String nombre;
	private String nombreCorto;
	private String descripcion;
	private String foto;
	
	@CreationTimestamp
	private Date fechaRegistro;
	@UpdateTimestamp
	private Date fechaActualizacion;
	
	private int estado;
	
//	@OneToMany(mappedBy="partidoPolitico", cascade = CascadeType.ALL,fetch=FetchType.LAZY)
//	private List<Candidato> candidatos;
	
	@OneToMany(mappedBy="partidoPolitico", fetch=FetchType.LAZY)
	@JsonIgnore
	private List<Candidato> candidatos;
	
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	
	public String getNombreCorto() {
		return nombreCorto;
	}

	public void setNombreCorto(String nombreCorto) {
		this.nombreCorto = nombreCorto;
	}

	public String getDescripcion() {
		return descripcion;
	}


	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}


	public String getFoto() {
		return foto;
	}


	public void setFoto(String foto) {
		this.foto = foto;
	}


	public Date getFechaRegistro() {
		return fechaRegistro;
	}


	public void setFechaRegistro(Date fechaRegistro) {
		this.fechaRegistro = fechaRegistro;
	}


	public int getEstado() {
		return estado;
	}


	public void setEstado(int estado) {
		this.estado = estado;
	}


	public List<Candidato> getCandidatos() {
		return candidatos;
	}


	public void setCandidatos(List<Candidato> candidatos) {
		this.candidatos = candidatos;
	}


	private static final long serialVersionUID = -5698831087875853251L;
}

