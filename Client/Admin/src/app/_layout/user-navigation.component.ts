import { Component, OnInit } from '@angular/core';
import { AuthService } from '../services/auth/auth-service.service';
import { Usuario } from '../model/usuario.model';
import { AccountService } from '../services/account/account.service';

@Component({
  selector: 'app-user-navigation',
  templateUrl: './user-navigation.component.html',
  styleUrls: ['./user-navigation.component.css']
})
export class UserNavigationComponent implements OnInit {
  usuario: Usuario = { nombre : '', apellido : '', correo : '', access_token : '', foto : '', refresh_token : '', id : 0};
  constructor(private authService: AuthService,
              private accountService: AccountService) { }

  ngOnInit() {
    this.accountService.obtenerDatosUsuario(this.authService.ObtenerUsuario().correo).subscribe((user: Usuario) => {
      this.usuario = user;
    });
  }
}
