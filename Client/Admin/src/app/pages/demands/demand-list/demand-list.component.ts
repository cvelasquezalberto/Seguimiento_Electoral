import { Component, OnInit} from '@angular/core';
import { DemandService } from 'src/app/services/demand/demand.service';
import { PartidoPolitico } from 'src/app/model/partido-Politico.model';
import { DenunciaCandidato } from 'src/app/model/denuncia-candidato.model';
import { Denuncia } from 'src/app/model/denuncia.model';
import { AuthService } from 'src/app/services/auth/auth-service.service';
import { SeguimientoDenuncia } from 'src/app/model/seguimiento-denuncia.model';

@Component({
  selector: 'app-demand-list',
  templateUrl: './demand-list.component.html',
  styleUrls: ['./demand-list.component.css']
})
export class DemandListComponent implements OnInit {

  partidosPoliticos: PartidoPolitico[];
  denunciaCandidato: DenunciaCandidato[];
  denuncias: Denuncia[];
  idPartidoPoliticoSelect = 0;

  constructor(private demandService: DemandService,
              private authService: AuthService) { }

  ngOnInit() {
    this.cargarPartidosPoliticos();
    this.cargarDenuncias();
    this.listarDenunciasSeguidas();
  }

  cargarPartidosPoliticos() {
    this.demandService.listarPartidoPolitico().subscribe((partidosPoliticos: PartidoPolitico[]) => {
    this.partidosPoliticos = partidosPoliticos;
    });
  }

  cargarDenuncias() {
    this.demandService.listarDenuncias(this.idPartidoPoliticoSelect, this.authService.ObtenerUsuario().id)
                      .subscribe((denuncias: DenunciaCandidato[]) => {
                          this.denunciaCandidato = denuncias;
                      });
  }

  listarDenunciasSeguidas() {
    const idUsuario = this.authService.ObtenerUsuario().id;
    this.demandService.listarDenunciasSeguidas(this.authService.ObtenerUsuario().id).subscribe((denuncias: Denuncia[]) => {
      this.denuncias = denuncias;
     });
  }

  registrarSeguimiento(idDenuncia: number) {
    const seguimiento: SeguimientoDenuncia = new SeguimientoDenuncia();
    seguimiento.idDenuncia = idDenuncia;
    seguimiento.idUsuario =  this.authService.ObtenerUsuario().id;
    this.demandService.registrarSeguimiento(seguimiento).subscribe((seg: SeguimientoDenuncia) => {
        // const denuncia: any = this.denuncias.find(x => x.id === seg.idDenuncia);
        // if (denuncia !== undefined) {
        //   denuncia.totalSeguimiento = seg.total;
        // }
        this.listarDenunciasSeguidas();
        const denunciaCand: any = this.denunciaCandidato.find(x => x.id === seg.idDenuncia);
        if (denunciaCand !== undefined) {
          denunciaCand.totalSeguimiento = seg.total;
        }

     });

  }
}
