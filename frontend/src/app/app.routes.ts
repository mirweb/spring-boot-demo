import { Routes } from '@angular/router';
import { FeaturePageComponent } from './feature-page.component';
import { HomePageComponent } from './home-page.component';

export const routes: Routes = [
  {
    path: '',
    component: HomePageComponent
  },
  {
    path: 'feature',
    component: FeaturePageComponent
  }
];
