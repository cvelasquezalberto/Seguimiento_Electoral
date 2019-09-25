import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { HttpClientModule } from '@angular/common/http';
import { RouterModule } from '@angular/router';
import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { LoginComponent } from './pages/login/login.component';
import { UserLayoutComponent } from './_layout/user-layout.component';
import { MydemandComponent } from './pages/demands/mydemand/mydemand.component';
import { RegisterDemandComponent } from './pages/demands/register-demand/register-demand.component';
import { DetailDemandComponent } from './pages/demands/detail-demand/detail-demand.component';
import { TopDemandComponent } from './pages/demands/top-demand/top-demand.component';
import { UserNavigationComponent } from './_layout/user-navigation.component';
import { UserGuardService } from './services/guards/user-guard.service';
import { SafePipe } from './pipes/sife.pipe';
import { CutTextPipe } from './pipes/cut-text.pipe';
import { RegisterComponent } from './pages/account/register.component';
import { DemandListComponent } from './pages/demands/demand-list/demand-list.component';

@NgModule({
  declarations: [
    AppComponent,
    LoginComponent,
    UserLayoutComponent,
    MydemandComponent,
    RegisterDemandComponent,
    DetailDemandComponent,
    TopDemandComponent,
    UserNavigationComponent,
    SafePipe,
    CutTextPipe,
    RegisterComponent,
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
          { path: 'misdemandas', component: MydemandComponent, canActivate: [UserGuardService]},
          { path: 'registrar', component: RegisterDemandComponent, canActivate: [UserGuardService]},
          { path: 'detalle/:id', component: DetailDemandComponent, canActivate: [UserGuardService]},
          { path: 'top', component: TopDemandComponent, canActivate: [UserGuardService]},
          { path: 'lista', component: DemandListComponent, canActivate: [UserGuardService]}
        ]
      },
      {
        path: 'cuenta',
        component: UserLayoutComponent,
        children: [
          { path: 'registrar', component: RegisterComponent}
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
