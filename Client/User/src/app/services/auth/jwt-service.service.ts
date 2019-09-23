import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root'
})
export class JwtService {

  readonly TOKEN_KEY: string = 'SEG_ELECT_PE';

  constructor() { }

  getToken(): string {
    return window.localStorage.getItem(this.TOKEN_KEY);
  }

  setToken(token: string): void {
      window.localStorage.setItem(this.TOKEN_KEY, token);
  }

  removeToken(): void {
    window.localStorage.removeItem(this.TOKEN_KEY);
  }

  tokenExists(): boolean {
    return !!this.getToken();
  }
}
