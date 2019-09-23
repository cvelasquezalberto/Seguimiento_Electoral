package com.upc.auth.entidades;

import java.util.List;

public class Usuario {
	private Long idUsuario;
	private String nombre;
	private String apellido;
	private String correo;
	private String contrasena;
	private List<Rol> listaRol;
	
	public Long getIdUsuario() {
		return idUsuario;
	}
	public void setIdUsuario(Long idUsuario) {
		this.idUsuario = idUsuario;
	}
	public String getNombre() {
		return nombre;
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
	public String getCorreo() {
		return correo;
	}
	public void setCorreo(String correo) {
		this.correo = correo;
	}
	
	public String getContrasena() {
		return contrasena;
	}
	public void setContrasena(String password) {
		this.contrasena = password;
	}
	public List<Rol> getListaRol() {
		return listaRol;
	}
	public void setListaRol(List<Rol> listaRol) {
		this.listaRol = listaRol;
	}
	
}
