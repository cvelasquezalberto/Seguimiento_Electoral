import { Evidencia } from './evidencia.model';

export interface DenunciaCandidato {
    id: number;
    titulo: string;
    descripcion: string;
    idEstado: number;
    nombreEstado: string;
    respuesta: string;
    partidoPolitico: string;
    fotoPartidoPolitico: string;
    ubicacion: string;
    nombreCandidato: string;
    fotoCandidato: string;
    cargoPolitico: string;
    fecha: string;
    evidencias: Evidencia[];
    totalSeguimiento: number;
}
