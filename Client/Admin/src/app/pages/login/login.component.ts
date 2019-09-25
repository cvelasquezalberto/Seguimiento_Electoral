import { Component, OnInit } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';
import {AuthService} from '../../services/auth/auth-service.service';
import swal from 'sweetalert2';
import Swal from 'sweetalert2';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css']
})
export class LoginComponent implements OnInit {
  usuario: string;
  password: string;
  errors: string[] = [];

  constructor(private authService: AuthService,
              private router: Router,
              private activatedRoute: ActivatedRoute) { }

  ngOnInit() {
  }

  login() {
    this.authService.autenticar(this.usuario, this.password).subscribe(
      data => this.router.navigateByUrl('seguimiento-electoral/bandeja'),
      httpError => {
        if (httpError.status === 400 ) {
          Swal.fire({title: 'Información', text: 'Usuario y/o contraseña incorrecta', type: 'warning' });
        } else if ( httpError.status === 401) {
          Swal.fire({title: 'Información', text: 'El usuario no se encuentra registrado', type: 'warning' });
        } else {
          Swal.fire({title: 'Información', text: 'Error al al realizar la operación', type: 'error' });
        }
      }
    );
  }
}
