import { mkdirSync, readFileSync, writeFileSync } from 'node:fs';
import { dirname, resolve } from 'node:path';
import { JSDOM } from 'jsdom';

const frontendDir = resolve(import.meta.dirname, '..');
const pomPath = resolve(frontendDir, '../pom.xml');
const outputPath = resolve(frontendDir, 'src/app/app-version.ts');
const pom = readFileSync(pomPath, 'utf8');
const parser = new JSDOM('').window.DOMParser;
const document = new parser().parseFromString(pom, 'application/xml');
const project = document.documentElement;

if (project.tagName !== 'project') {
  throw new Error(`Could not read <project> from ${pomPath}`);
}

const readProjectChild = (tagName) => {
  const child = Array.from(project.children).find((element) => element.tagName === tagName);

  if (!child?.textContent?.trim()) {
    throw new Error(`Could not read <${tagName}> from ${pomPath}`);
  }

  return child.textContent.trim();
};

const appName = readProjectChild('name');
const version = readProjectChild('version');
const source = `export const APP_METADATA = ${JSON.stringify(
  {
    name: appName,
    version
  },
  null,
  2
)} as const;\n`;

mkdirSync(dirname(outputPath), { recursive: true });
writeFileSync(outputPath, source, 'utf8');
