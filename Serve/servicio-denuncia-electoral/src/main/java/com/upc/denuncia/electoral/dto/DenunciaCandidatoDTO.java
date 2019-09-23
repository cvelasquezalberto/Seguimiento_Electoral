package com.upc.denuncia.electoral.dto;

import java.io.Serializable;
import java.util.List;

public class DenunciaCandidatoDTO implements Serializable {
	public Long id;
	public String titulo;
	public String descripcion;
	public Long idEstado;
	public String nombreEstado;
	public String respuesta;
	public String partidoPolitico;
	public String fotoPartidoPolitico;
	public String ubicacion;
	public String nombreCandidato;
	public String fotoCandidato;
	public String cargoPolitico;
	public String fecha;
	public List<EvidenciaDTO> evidencias;
	public Long totalSeguimiento;
	public boolean siguiendo;
	
	private static final long serialVersionUID = 8812845191790252947L;
}
