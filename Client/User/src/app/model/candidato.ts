import { PartidoPolitico } from './partido-Politico.model';
import { CargoPolitico } from './cargo-politico';

export interface Candidato {
    id: number;
    nombre: string;
    apellido: string;
    foto: string;
    partidoPolitico: PartidoPolitico;
    cargoPolitico: CargoPolitico;
}
