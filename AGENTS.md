## Changelog policy
- Maintain `CHANGELOG.md` following https://keepachangelog.com/en/1.0.0/.
- Before every commit, verify `CHANGELOG.md` is updated to reflect the changes.

## Commit policy
- Create commit messages following https://www.conventionalcommits.org/en/v1.0.0/.

## Documentation policy
- Maintain technical documentation under `docs/` using Markdown files only.
- Update relevant files in `docs/` when code changes affect architecture, workflows, operations, interfaces, or technical decisions.
- Record new or changed architectural decisions as Markdown ADRs under `docs/adr/`.
- Keep OpenAPI/Swagger documentation accurate when API endpoints, parameters, or response contracts change.

## CI policy
- Keep `.gitlab-ci.yml` aligned with the supported build and test workflow.
- Update CI-related documentation when validation, release, or contributor expectations change.
- Keep GitLab test report publishing aligned with the actual Maven and frontend test commands.
