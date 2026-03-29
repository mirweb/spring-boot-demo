## Language policy
- Write all repository-related content in English.
- Use English for issues, merge requests, commit messages, changelog entries, documentation, code comments, and assistant responses about this repository unless the user explicitly requests another language for a specific task.

## Changelog policy
- Maintain `CHANGELOG.md` following https://keepachangelog.com/en/1.0.0/.
- Before every commit, verify `CHANGELOG.md` is updated to reflect the changes.
- When work is done for a GitLab issue, mention the issue in the relevant changelog entry and include a Markdown link to the GitLab issue or work item.

## Commit policy
- Create commit messages following https://www.conventionalcommits.org/en/v1.0.0/.
- When a commit belongs to a GitLab issue, add a GitLab-style issue reference in the commit message footer, for example `Refs: #6` or `Closes: #6` when appropriate.

## Documentation policy
- Maintain technical documentation under `docs/` using Markdown files only.
- Update relevant files in `docs/` when code changes affect architecture, workflows, operations, interfaces, or technical decisions.
- Record new or changed architectural decisions as Markdown ADRs under `docs/adr/`.
- Keep OpenAPI/Swagger documentation accurate when API endpoints, parameters, or response contracts change.

## Angular update policy
- Use `npx ng update @angular/core @angular/cli` to update Angular — do not manually edit version numbers in `package.json`.
- `ng update` handles peer dependencies and runs migrations automatically.
- For major version updates, consult https://update.angular.io for the step-by-step guide.

## CI policy
- Keep `.gitlab-ci.yml` aligned with the supported build and test workflow.
- Update CI-related documentation when validation, release, or contributor expectations change.
- Keep GitLab test report publishing aligned with the actual Maven and frontend test commands.
