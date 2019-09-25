import { Observable, throwError } from 'rxjs';
import { Usuario } from '../../model/usuario.model';
import { HttpClient, HttpErrorResponse, HttpHeaders, HttpResponse } from '@angular/common/http';
import {JwtService} from '../auth/jwt-service.service';
import {ApiService} from '../rest/api.service';
import { Injectable } from '@angular/core';
import { map, tap, catchError } from 'rxjs/operators';
import { Denuncia } from 'src/app/model/denuncia.model';
import { PartidoPolitico } from 'src/app/model/partido-Politico.model';
import { Candidato } from 'src/app/model/candidato';
import { DenunciaCandidato } from 'src/app/model/denuncia-candidato.model';
import { SeguimientoDenuncia } from 'src/app/model/seguimiento-denuncia.model';
import { Estado } from 'src/app/model/estado.model';


@Injectable({
    providedIn: 'root'
  })
export class DemandService {

    constructor(private jwtService: JwtService,
                private apiService: ApiService
       ) { }

    obtenerMisDenuncias(idUsuario: number): Observable<Denuncia[]> {
        return this.apiService.get(`/api/seguimiento-electoral/denuncias/${idUsuario}/mis-denuncias`)
                              .pipe(tap(data => data), catchError(this.handleError));
    }

    listarPartidoPolitico(): Observable<PartidoPolitico[]> {
        return this.apiService.get('/api/seguimiento-electoral/partidos-politicos/')
                              .pipe(tap(data => data), catchError(this.handleError));
    }

    listarCandidatoPorPartido(id: number): Observable<Candidato[]> {
        return this.apiService.get(`/api/seguimiento-electoral/partidos-politicos/${id}/candidatos`)
                              .pipe(tap(data => data), catchError(this.handleError));
    }

    registrarDenuncia(formData: FormData): Observable<Denuncia> {
        return this.apiService.postFormData(`/api/seguimiento-electoral/denuncias/v2`, formData)
                              .pipe(tap(data => data), catchError(this.handleError));
    }

    obtenerDenunciaPorId(id: string): Observable<DenunciaCandidato> {
        return this.apiService.get(`/api/seguimiento-electoral/denuncias/${id}/detalle`)
                              .pipe(tap(data => data), catchError(this.handleError));
    }

    obtenerEvidenciaPorId(id: number) {
        return this.apiService.get_Blob(`/api/seguimiento-electoral/denuncias/evidencias/${id}`)
                              .pipe(tap(data => data), catchError(this.handleError));
    }

    listarDenunciasTop(idPartidoPolitico: number , idUsuario: number): Observable<DenunciaCandidato[]> {
        // tslint:disable-next-line:max-line-length
        return this.apiService.get(`/api/seguimiento-electoral/partidos-politicos/${idPartidoPolitico}/denuncias/top?idUsuario=${idUsuario}`)
                              .pipe(tap(data => data), catchError(this.handleError));
    }

    listarDenuncias(idPartidoPolitico: number, idUsuario: number): Observable<DenunciaCandidato[]> {
        return this.apiService.get(`/api/seguimiento-electoral/partidos-politicos/${idPartidoPolitico}/denuncias?idUsuario=${idUsuario}`)
                              .pipe(tap(data => data), catchError(this.handleError));
    }

    listarDenunciasSeguidas(idUsuario: number): Observable<Denuncia[]> {
        return this.apiService.get(`/api/seguimiento-electoral/denuncias/usuarios/${idUsuario}/seguimiento`)
                              .pipe(tap(data => data), catchError(this.handleError));
    }

    registrarSeguimiento(seguimiento: SeguimientoDenuncia): Observable<SeguimientoDenuncia> {
        return this.apiService.post('/api/seguimiento-electoral/denuncias/seguimiento', seguimiento)
                              .pipe(tap(data => data), catchError(this.handleError));
    }

    listarEstado(): Observable<Estado[]> {
        return this.apiService.get(`/api/seguimiento-electoral/denuncias/estados`)
                              .pipe(tap(data => data), catchError(this.handleError));
    }

    public handleError(errorResponse: HttpErrorResponse) {
        if (errorResponse.error.message !== undefined) {
            alert(errorResponse.error.message);

            return;
        }

        if (errorResponse.error instanceof ErrorEvent) {
            console.error('An error occurred:', errorResponse.error.message);
        } else {
            console.error(`Backend returned code ${errorResponse.status}, ` + `body was: ${errorResponse.error}`);
        }
        return throwError('Something bad happened; please try again later.');
    }
}
