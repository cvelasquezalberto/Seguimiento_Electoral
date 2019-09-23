import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { JwtService } from '../services/auth/jwt-service.service';

@Component({
  selector: 'app-user-layout',
  templateUrl: './user-layout.component.html',
  styleUrls: ['./user-layout.component.css']
})
export class UserLayoutComponent implements OnInit {

  constructor(private router: Router,
              private jwtService: JwtService) { }

  ngOnInit() {
  }

  cerrarSesion() {
    this.jwtService.removeToken();
    this.router.navigateByUrl('/auth');
  }
}
