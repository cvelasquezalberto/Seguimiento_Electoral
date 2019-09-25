import { Injectable } from '@angular/core';
import { JwtService } from '../auth/jwt-service.service';
import { ApiService } from '../rest/api.service';
import { Observable, throwError } from 'rxjs';
import { Persona } from 'src/app/model/persona.model';
import { tap, catchError } from 'rxjs/operators';
import { HttpErrorResponse } from '@angular/common/http';
import { Usuario } from 'src/app/model/usuario.model';


@Injectable({
    providedIn: 'root'
  })
export class AccountService {
    constructor(private jwtService: JwtService,
                private apiService: ApiService
                ) { }

    obtenerDatosUsuario(correo: string): Observable<Usuario> {
        return this.apiService.get(`/api/servicio-usuario/usuarios/${correo}/foto`)
                              .pipe(tap(data => data), catchError(this.handleError));
    }

    validarDni(dni: string): Observable<Persona> {
        return this.apiService.getExt(`/api/externo/reniec/persona/${dni}`)
                              .pipe(tap(data => data), catchError(this.handleError));
    }

    registrar(formData: FormData): Observable<Usuario> {
        return this.apiService.postFormDataExt('/api/servicio-usuario/usuarios/v2', formData)
                              .pipe(tap(data => data), catchError(this.handleError));
    }

    public handleError(errorResponse: HttpErrorResponse) {
        if (errorResponse.error.message !== undefined) {
            alert(errorResponse.error.message);

            return;
        }
        return throwError('Something bad happened; please try again later.');
    }
}
