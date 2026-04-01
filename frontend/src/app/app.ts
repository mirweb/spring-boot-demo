import { Component, OnInit, signal } from '@angular/core';
import { RouterLink, RouterLinkActive, RouterOutlet } from '@angular/router';
import { APP_METADATA } from './app-version';

interface AppInfo {
  name: string;
  version: string;
}

@Component({
  selector: 'app-root',
  imports: [RouterLink, RouterLinkActive, RouterOutlet],
  templateUrl: './app.html',
  styleUrl: './app.css'
})
export class App implements OnInit {
  protected readonly appName = signal<string>(APP_METADATA.name);
  protected readonly appVersion = signal<string>('…');

  async ngOnInit(): Promise<void> {
    try {
      const response = await fetch('/api/info');
      if (!response.ok) {
        throw new Error(`Backend returned ${response.status}`);
      }
      const info = (await response.json()) as AppInfo;
      this.appName.set(info.name);
      this.appVersion.set(info.version);
    } catch {
      this.appVersion.set(APP_METADATA.version);
    }
  }
}
