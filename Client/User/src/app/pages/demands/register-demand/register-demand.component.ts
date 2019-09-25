import { Component, OnInit } from '@angular/core';
import { AuthService } from 'src/app/services/auth/auth-service.service';
import { DemandService } from 'src/app/services/demand/demand.service';
import { PartidoPolitico } from 'src/app/model/partido-Politico.model';
import { Candidato } from 'src/app/model/candidato';
import { Denuncia } from 'src/app/model/denuncia.model';
import { Router } from '@angular/router';
import Swal from 'sweetalert2';

@Component({
  selector: 'app-register-demand',
  templateUrl: './register-demand.component.html',
  styleUrls: ['./register-demand.component.css']
})
export class RegisterDemandComponent implements OnInit {

  partidosPoliticos: PartidoPolitico[];
  candidatos: Candidato[];
  titulo: string;
  descripcion: string;
  candidato: Candidato;
  idCandidato = 0;
  file1: File;
  file2: File;

  constructor(private authService: AuthService,
              private demandService: DemandService,
              private router: Router) { }


  ngOnInit() {
    this.cargarPartidosPoliticos();
  }

  cargarPartidosPoliticos() {
      this.demandService.listarPartidoPolitico().subscribe((partidosPoliticos: PartidoPolitico[]) => {
      this.partidosPoliticos = partidosPoliticos;
    });
  }

  cargarCandidatos(idPartido: number) {
      this.demandService.listarCandidatoPorPartido(idPartido).subscribe((candidatos: Candidato[]) => {
      this.candidatos = candidatos;
    });
  }

  onFile1Select(event) {
    if (event.target.files.length > 0) {
      this.file1 = event.target.files[0];
    }
  }

  onFile2Select(event) {
    if (event.target.files.length > 0) {
      this.file2 = event.target.files[0];
    }
  }

  registrarDenuncia() {
    const formData = new FormData();
    formData.append('titulo', this.titulo);
    formData.append('descripcion', this.descripcion);
    formData.append('idCandidato', this.idCandidato.toString());
    formData.append('idUsuario', this.authService.ObtenerUsuario().id.toString());
    formData.append('file1', this.file1);
    formData.append('file2', this.file2);

    this.demandService.registrarDenuncia(formData).subscribe((denuncia: Denuncia) => {
        Swal.fire({title: 'Información', text: 'Su denuncia se registró con éxito', type: 'success' });
        this.router.navigateByUrl('seguimiento-electoral/misdemandas');
    });
  }
}
