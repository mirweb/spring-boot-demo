import { TestBed } from '@angular/core/testing';
import { provideRouter, Router } from '@angular/router';
import { vi } from 'vitest';
import { App } from './app';
import { routes } from './app.routes';
import { APP_METADATA } from './app-version';

describe('App', () => {
  beforeEach(async () => {
    vi.stubGlobal('fetch', vi.fn().mockImplementation((url: string) => {
      if (url === '/api/info') {
        return Promise.resolve({ ok: true, json: async () => ({ name: 'spring-boot-demo', version: '1.2.3' }) });
      }
      return Promise.resolve({ ok: true, json: async () => ({ message: 'Hello Angular!' }) });
    }));

    await TestBed.configureTestingModule({
      imports: [App],
      providers: [provideRouter(routes)]
    }).compileComponents();
  });

  afterEach(() => {
    vi.unstubAllGlobals();
  });

  it('should create the app', () => {
    const fixture = TestBed.createComponent(App);
    const app = fixture.componentInstance;
    expect(app).toBeTruthy();
  });

  it('should render the routed shell with footer metadata', async () => {
    const router = TestBed.inject(Router);
    const fixture = TestBed.createComponent(App);
    await router.navigateByUrl('/');
    fixture.detectChanges();
    await fixture.whenStable();
    await new Promise(resolve => setTimeout(resolve));
    fixture.detectChanges();

    const compiled = fixture.nativeElement as HTMLElement;
    const bodyText = compiled.querySelector('.app-body')?.textContent ?? '';

    expect(compiled.querySelector('h1')?.textContent).toContain(APP_METADATA.name);
    expect(compiled.querySelector('.app-nav')?.textContent).toContain('Main page');
    expect(compiled.querySelector('.app-nav')?.textContent).toContain('Feature page');
    expect(bodyText).toContain('Current application content stays on the default route.');
    expect(bodyText).toContain('API response');
    expect(compiled.querySelector('.app-footer')?.textContent).toContain('spring-boot-demo');
    expect(compiled.querySelector('.app-footer')?.textContent).toContain('1.2.3');
  });
});
