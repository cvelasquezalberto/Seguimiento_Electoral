import { Injectable } from '@angular/core';
import { Router, CanActivate } from '@angular/router';
import { AuthService } from '../auth/auth-service.service';

@Injectable({
    providedIn: 'root'
})
export class UserGuardService implements CanActivate {

    constructor(private router: Router, private authService: AuthService) { }

    canActivate() {
        if (this.authService.esUsuarioAutenticado()) {
            return true;
        }

        // not logged in so redirect to login page
        this.router.navigate(['/Login']);
        return false;
    }
}
