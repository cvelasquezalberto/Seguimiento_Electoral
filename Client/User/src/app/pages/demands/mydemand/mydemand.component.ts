import { Component, OnInit } from '@angular/core';
import { AuthService } from 'src/app/services/auth/auth-service.service';
import { Usuario } from 'src/app/model/usuario.model';
import { DemandService } from 'src/app/services/demand/demand.service';
import { Denuncia } from 'src/app/model/denuncia.model';

@Component({
  selector: 'app-mydemand',
  templateUrl: './mydemand.component.html',
  styleUrls: ['./mydemand.component.css']
})
export class MydemandComponent implements OnInit {

  denuncias: Denuncia[];
  constructor(private authService: AuthService,
              private demandService: DemandService) { }

  ngOnInit() {
    this.cargarDenuncias();
  }

  cargarDenuncias() {
    const usuario: Usuario = this.authService.ObtenerUsuario();
    this.demandService.obtenerMisDenuncias(usuario.id).subscribe((denuncias: Denuncia[]) => {
      this.denuncias = denuncias;
    });
  }
}
