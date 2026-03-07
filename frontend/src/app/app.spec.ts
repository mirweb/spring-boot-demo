import { TestBed } from '@angular/core/testing';
import { vi } from 'vitest';
import { App } from './app';
import { APP_METADATA } from './app-version';

describe('App', () => {
  beforeEach(async () => {
    vi.stubGlobal('fetch', vi.fn().mockResolvedValue({
      ok: true,
      json: async () => ({ message: 'Hello Angular!' })
    }));

    await TestBed.configureTestingModule({
      imports: [App],
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

  it('should render the integrated shell', async () => {
    const fixture = TestBed.createComponent(App);
    await fixture.whenStable();
    fixture.detectChanges();
    const compiled = fixture.nativeElement as HTMLElement;
    expect(compiled.querySelector('h1')?.textContent).toContain('Integrated frontend');
    expect(compiled.querySelector('.response-text')?.textContent).toContain('Hello Angular!');
    expect(compiled.querySelector('.app-footer')?.textContent).toContain(APP_METADATA.name);
    expect(compiled.querySelector('.app-footer')?.textContent).toContain(APP_METADATA.version);
  });
});
