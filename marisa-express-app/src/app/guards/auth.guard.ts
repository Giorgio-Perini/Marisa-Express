import { Injectable } from '@angular/core';
import { CanActivate, Router } from '@angular/router';

@Injectable({ providedIn: 'root' })
export class AuthGuard implements CanActivate {
  constructor(private router: Router) {}

  canActivate(): boolean {
    const token = localStorage.getItem('marisa_token');
    if (token) return true;
    window.location.href = 'http://marisa-express-server-01:3001';
    return false;
  }
}
