import { Component, OnInit } from '@angular/core';
import { Denuncia } from 'src/app/model/denuncia.model';
import { DemandService } from 'src/app/services/demand/demand.service';
import { ActivatedRoute } from '@angular/router';
import { DenunciaCandidato } from 'src/app/model/denuncia-candidato.model';
import { Estado } from 'src/app/model/estado.model';

@Component({
  selector: 'app-detail-demand',
  templateUrl: './detail-demand.component.html',
  styleUrls: ['./detail-demand.component.css']
})
export class DetailDemandComponent implements OnInit {
  denuncia: DenunciaCandidato;
  listaEstado: Estado[];
  estado: number;
  respuesta: string;

  constructor(private demandService: DemandService,
              private route: ActivatedRoute) { }

  ngOnInit() {
    this.obtenerDenuncia();
    this.cargarEstado();
  }

  cargarEstado() {
    this.route.paramMap.subscribe(params => {
      this.demandService.listarEstado().subscribe((listaEstado: Estado[]) => {
        this.listaEstado = listaEstado;
      });
    });
  }

  obtenerDenuncia() {
    this.route.paramMap.subscribe(params => {
      this.demandService.obtenerDenunciaPorId(params.get('id')).subscribe((denuncia: DenunciaCandidato) => {
        this.denuncia = denuncia;
      });
    });
  }

  descargarEvidencia(id: number, archivo: string) {
    this.demandService.obtenerEvidenciaPorId(id).subscribe((val) => {
      this.forceFileDownload(val, archivo);
    });
  }

  forceFileDownload(response, archivo: string) {
    const url = window.URL.createObjectURL(new Blob([response]));
    const link = document.createElement('a');
    link.href = url;
    link.target = '_blank';
    link.download = archivo;
    link.click();
  }
}

