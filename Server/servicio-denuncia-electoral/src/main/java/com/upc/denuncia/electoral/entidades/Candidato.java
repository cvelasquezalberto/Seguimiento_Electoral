package com.upc.denuncia.electoral.entidades;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import javax.persistence.Transient;

import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

@Entity
@Table(name = "Candidato")
public class Candidato implements Serializable{

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;
	private String nombre;
	private String apellido;
	private String foto;
	private int idUsuario;
	@CreationTimestamp
	private Date fechaRegistro;
	@UpdateTimestamp
	private Date fechaActualizacion;
	private int estado;
	
	@Transient
	private Long idPartidoPolitico;
	
	@Transient
	private Long idCargoPolitico;
	
	@ManyToOne(optional = false, fetch = FetchType.EAGER)
	private PartidoPolitico partidoPolitico;
	
	@ManyToOne(optional = false, fetch = FetchType.EAGER)
	private CargoPolitico cargoPolitico;
	
	@OneToMany(mappedBy="candidato", fetch=FetchType.LAZY)
	private List<Denuncia> denuncias;
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getNombre() {
		return nombre;
	}
	public CargoPolitico getCargoPolitico() {
		return cargoPolitico;
	}
	public void setCargoPolitico(CargoPolitico cargoPolitico) {
		this.cargoPolitico = cargoPolitico;
	}
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	public String getApellido() {
		return apellido;
	}
	public void setApellido(String apellido) {
		this.apellido = apellido;
	}
	public PartidoPolitico getPartidoPolitico() {
		return partidoPolitico;
	}
	public void setPartidoPolitico(PartidoPolitico partidoPolitico) {
		this.partidoPolitico = partidoPolitico;
	}
	public List<Denuncia> getDenuncias() {
		return denuncias;
	}
	public void setDenuncias(List<Denuncia> denuncias) {
		this.denuncias = denuncias;
	}
	
	public String getFoto() {
		return foto;
	}
	public void setFoto(String foto) {
		this.foto = foto;
	}
	public int getIdUsuario() {
		return idUsuario;
	}
	public void setIdUsuario(int idUsuario) {
		this.idUsuario = idUsuario;
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

	public Long getIdPartidoPolitico() {
		return idPartidoPolitico;
	}
	public void setIdPartidoPolitico(Long idPartidoPolitico) {
		this.idPartidoPolitico = idPartidoPolitico;
	}
	public Long getIdCargoPolitico() {
		return idCargoPolitico;
	}
	public void setIdCargoPolitico(Long idCargoPolitico) {
		this.idCargoPolitico = idCargoPolitico;
	}

	private static final long serialVersionUID = -6191509406582177663L;

}
