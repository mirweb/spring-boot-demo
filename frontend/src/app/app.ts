import { Component, signal } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { APP_METADATA } from './app-version';

type HelloResponse = {
  message: string;
};

@Component({
  selector: 'app-root',
  imports: [FormsModule],
  templateUrl: './app.html',
  styleUrl: './app.css'
})
export class App {
  protected readonly appName = APP_METADATA.name;
  protected readonly appVersion = APP_METADATA.version;
  protected readonly name = signal('Angular');
  protected readonly message = signal('Loading greeting...');
  protected readonly loading = signal(false);
  protected readonly error = signal('');

  constructor() {
    void this.loadGreeting();
  }

  protected async loadGreeting(): Promise<void> {
    this.loading.set(true);
    this.error.set('');

    const params = new URLSearchParams();
    const trimmedName = this.name().trim();

    if (trimmedName) {
      params.set('name', trimmedName);
    }

    const query = params.size > 0 ? `?${params.toString()}` : '';

    try {
      const response = await fetch(`/api/hello${query}`);

      if (!response.ok) {
        throw new Error(`Backend returned ${response.status}`);
      }

      const body = (await response.json()) as HelloResponse;
      this.message.set(body.message);
    } catch (error) {
      this.error.set(error instanceof Error ? error.message : 'Unknown error');
      this.message.set('Greeting unavailable');
    } finally {
      this.loading.set(false);
    }
  }
}
