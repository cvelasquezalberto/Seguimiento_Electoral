import { Component, OnInit } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';
import {AuthService} from '../../services/auth/auth-service.service';

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
      data => this.router.navigateByUrl('seguimiento-electoral/top'),
      httpError => {
        if (httpError.status === 400 ) {
          alert('Usuario y/o contraseña incorrecta');
        } else if ( httpError.status === 401) {
          return alert('El usuario no se encuentra registrado');
        } else {
          return alert('Error al al realizar la operación');
        }
      }
    );
  }
}
