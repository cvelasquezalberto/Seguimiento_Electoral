import { Observable, BehaviorSubject } from 'rxjs';
import { Usuario } from '../../model/usuario.model';
import {JwtService} from './jwt-service.service';
import {ApiService} from '../rest/api.service';
import { Injectable } from '@angular/core';
import { map , distinctUntilChanged} from 'rxjs/operators';

@Injectable({
  providedIn: 'root'
})
export class AuthService {

  private isAuthenticatedSubject: BehaviorSubject<boolean> = new BehaviorSubject<boolean>(false);
  private authenticatedUserSubject: BehaviorSubject<Usuario> = new BehaviorSubject<Usuario>({} as Usuario);

  constructor(private jwtService: JwtService,
              private apiService: ApiService
             ) {
  this.cargarUsuarioAutenticado();
}

  cargarUsuarioAutenticado() {
    if (!this.jwtService.tokenExists()) {
      return;
    }
    this.asignarUsuarioAurtenticado(this.obtenerUsuarioToken(this.jwtService.getToken()));
  }

  autenticar(usuario: string, password: string): Observable<Usuario> {
    return this.apiService.post_token('/api/security/oauth/token', usuario, password)
                          .pipe(map(response => {
                            this.jwtService.setToken(response.access_token);
                            return this.asignarUsuarioAurtenticado(this.obtenerUsuarioToken(response.access_token));
                          }
                          ));
  }

    obtenerUsuarioToken(token): Usuario {
    return JSON.parse(decodeURIComponent(escape(atob(token.split('.')[1]))));
  }

  asignarUsuarioAurtenticado(usuario: Usuario) {
    this.isAuthenticatedSubject.next(true);
    this.authenticatedUserSubject.next(usuario);
    return usuario;
  }

  ObtenerUsuario(): Usuario {
    return this.authenticatedUserSubject.value;
  }

  logOut() {
    this.jwtService.removeToken();
    this.isAuthenticatedSubject.next(false);
    this.authenticatedUserSubject.next(null);
  }

  esUsuarioAutenticado(): boolean {
    return this.isAuthenticatedSubject.value;
  }
}
