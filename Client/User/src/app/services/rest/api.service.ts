import { Injectable } from '@angular/core';
import { HttpClient, HttpParams, HttpHeaders } from '@angular/common/http';
import { Observable } from 'rxjs';
import { JwtService } from '../auth/jwt-service.service';

@Injectable({
  providedIn: 'root'
})
export class ApiService {
  private baseUrl = 'http://localhost:8090';
  constructor(private httpClient: HttpClient,
              private jwtService: JwtService) { }

  private getHeaders(): HttpHeaders {
    const headers = new HttpHeaders()
    .set('Content-Type', 'application/json; charset=utf-8')
    .set('Authorization', `Bearer ${this.jwtService.getToken()}`);

    return headers;
  }

  get(url: string, params: HttpParams = new HttpParams()): Observable<any> {
    const headers = this.getHeaders();
    return this.httpClient.get(`${this.baseUrl}${url}`, { params, headers });
  }

  delete(url: string): Observable<any> {
    const headers = this.getHeaders();
    return this.httpClient.delete(`${this.baseUrl}${url}`, { headers });
  }

  post(url: string, data: object = {}): Observable<any> {
    const headers = this.getHeaders();
    return this.httpClient.post(`${this.baseUrl}${url}`, JSON.stringify(data), { headers });
  }

  postFormData(url: string, formdata: FormData): Observable<any> {
    const headers = new HttpHeaders()
                   .set('Authorization', `Bearer ${this.jwtService.getToken()}`);
    return this.httpClient.post(`${this.baseUrl}${url}`, formdata, { headers });
  }

  post_token(url: string, usuario: string, clave: string): Observable<any> {
    const data = `username=${usuario}&password=${clave}&grant_type=password`;
    const headers = new HttpHeaders()
                    .set('Content-Type', 'application/x-www-form-urlencoded')
                    .set('Authorization', 'Basic c2VndWltaWVudG8tYXBwOjEyMzQ1');
    return this.httpClient.post(`${this.baseUrl}${url}`, data, { headers });
  }

  get_Blob(url: string): Observable<any> {
    const headers = new HttpHeaders({
      'Content-Type': 'application/json',
       Accept: 'application/json',
       Authorization: `Bearer ${this.jwtService.getToken()}`
    });

    return this.httpClient.get(`${this.baseUrl}${url}`, { headers , responseType: 'blob' as 'json' });
  }

  put(url: string, data: object = {}): Observable<any> {
    const headers = this.getHeaders();
    return this.httpClient.put(`${this.baseUrl}${url}`, JSON.stringify(data), { headers });
  }
}
