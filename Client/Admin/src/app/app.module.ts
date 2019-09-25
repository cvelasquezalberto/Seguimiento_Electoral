import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { HttpClientModule } from '@angular/common/http';
import { RouterModule } from '@angular/router';
import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { LoginComponent } from './pages/login/login.component';
import { UserLayoutComponent } from './_layout/user-layout.component';
import { DetailDemandComponent } from './pages/demands/detail-demand/detail-demand.component';
import { UserNavigationComponent } from './_layout/user-navigation.component';
import { UserGuardService } from './services/guards/user-guard.service';
import { SafePipe } from './pipes/sife.pipe';
import { CutTextPipe } from './pipes/cut-text.pipe';
import { DemandListComponent } from './pages/demands/demand-list/demand-list.component';
import { BandejaDemandComponent } from './pages/demands/bandeja-demand/bandeja-demand.component';

@NgModule({
  declarations: [
    AppComponent,
    LoginComponent,
    UserLayoutComponent,
    BandejaDemandComponent,
    DetailDemandComponent,
    UserNavigationComponent,
    SafePipe,
    CutTextPipe,
    DemandListComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    FormsModule,
    HttpClientModule,
    RouterModule.forRoot([
      {
        path: 'seguimiento-electoral',
        component: UserLayoutComponent,
        children: [
          { path: 'bandeja', component: BandejaDemandComponent, canActivate: [UserGuardService]},
          { path: 'detalle/:id', component: DetailDemandComponent, canActivate: [UserGuardService]}
        ]
      },
      {
        path : 'Login', component: LoginComponent
      },
      { path: '', redirectTo: 'Login', pathMatch: 'full' },
      { path: '**', redirectTo: 'Login', pathMatch: 'full' },
    ])
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
