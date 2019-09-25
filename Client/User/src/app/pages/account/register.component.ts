import { Component, OnInit } from '@angular/core';
import { AccountService } from 'src/app/services/account/account.service';
import { Persona } from 'src/app/model/persona.model';
import { Usuario } from 'src/app/model/usuario.model';
import { Router } from '@angular/router';
import Swal from 'sweetalert2';

@Component({
  selector: 'app-register',
  templateUrl: './register.component.html',
  styleUrls: ['./register.component.css']
})
export class RegisterComponent implements OnInit {
  persona: Persona;
  dni: string;
  fechaEmision: string;
  correo: string;
  contrasena: string;
  file1: File;
  urlImage: any;

  constructor(private accountService: AccountService,
              private router: Router) {
    this.persona = new Persona();
  }

  ngOnInit() {
  }

  validarDocumento() {
    this.accountService.validarDni(this.dni).subscribe((persona: Persona) => {
      if (persona.dni === '') {
        this.persona.apellidos = '';
        this.persona.nombres = '';
        this.persona.direccion = '';
        Swal.fire({title: 'Información', text: 'No se encontró información', type: 'warning' });
      } else {
        this.persona = persona;
      }
    });
  }

  onFileSelect(event) {
    if (event.target.files.length > 0) {
      this.file1 = event.target.files[0];
      const reader = new FileReader();

      reader.readAsDataURL(event.target.files[0]); // read file as data url

      reader.onload = (e: Event) => {
        this.urlImage = reader.result;
      };
    }
  }

  registrarUsuario() {
    const formData = new FormData();
    formData.append('nombre', this.persona.nombres);
    formData.append('apellido', this.persona.apellidos);
    formData.append('dni', this.persona.dni);
    formData.append('correo', this.correo);
    formData.append('contrasena', this.contrasena);
    formData.append('file1', this.file1);

    this.accountService.registrar(formData).subscribe((usuario: Usuario) => {
      alert('Se registró correctamente');
      this.router.navigateByUrl('Login');
    });
  }
}
