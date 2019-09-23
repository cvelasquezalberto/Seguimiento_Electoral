package com.upc.denuncia.electoral.entidades;

import java.io.Serializable;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import javax.persistence.Transient;
import javax.validation.constraints.NotBlank;

import org.hibernate.annotations.CreationTimestamp;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonProperty.Access;

@Entity
@Table(name = "Denuncia")
public class Denuncia implements Serializable {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;
	
	@NotBlank(message = "Ingrese el título")
	private String titulo;
	
	@NotBlank(message = "Ingrese la descripción")
	@Column(length = 5000)
	private String descripcion;
	
	@Transient
	@JsonProperty(access = Access.WRITE_ONLY)
	private Long idCandidato;
	
	@ManyToOne(optional = false, fetch = FetchType.LAZY)
	@JsonIgnore
	private Candidato candidato;
	
	@ManyToOne(optional = false, fetch = FetchType.LAZY)
	@JsonIgnore
	private Estado estado;
	
	@OneToMany(mappedBy="denuncia", fetch=FetchType.LAZY)
	@JsonIgnore
	private List<DocumentoAdjunto> documentosAdjuntos;
	
	private int idUsuario;
	
	@CreationTimestamp
	private Date fechaRegistro;
	
	private String respuesta;	
	
	private Long totalSeguimiento;
	
	public int getIdUsuario() {
		return idUsuario;
	}

	public void setIdUsuario(int idUsuario) {
		this.idUsuario = idUsuario;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

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
	
	public Candidato getCandidato() {
		return candidato;
	}

	public void setCandidato(Candidato candidato) {
		this.candidato = candidato;
	}
	
	public Long getIdCandidato() {
		return idCandidato;
	}

	public void setIdCandidato(Long idCandidato) {
		this.idCandidato = idCandidato;
	}
	
	public Long getCandidato_id(){
        return candidato.getId();
    }

    public String getNombreCandidato(){
        return candidato.getNombre() + " " + candidato.getApellido();
    }
    
	public Estado getEstado() {
		return estado;
	}

	public void setEstado(Estado estado) {
		this.estado = estado;
	}
	
	public Long getEstado_id(){
        return estado.getId();
    }

    public String getNombreEstado(){
        return estado.getNombre();
    }
    
    public String getFecha() {
    	SimpleDateFormat dt = new SimpleDateFormat("MM-dd-yyyy"); 
    	return dt.format(fechaRegistro);
    }
    
    public String getRespuesta() {
		return respuesta;
	}

	public void setRespuesta(String respuesta) {
		this.respuesta = respuesta;
	}
    
	public List<DocumentoAdjunto> getDocumentosAdjuntos() {
		return documentosAdjuntos;
	}

	public void setDocumentosAdjuntos(List<DocumentoAdjunto> documentosAdjuntos) {
		this.documentosAdjuntos = documentosAdjuntos;
	}
	
	public Long getTotalSeguimiento() {
		return totalSeguimiento;
	}

	public void setTotalSeguimiento(Long totalSeguimiento) {
		this.totalSeguimiento = totalSeguimiento;
	}



	private static final long serialVersionUID = -8918144072549684271L;
}
