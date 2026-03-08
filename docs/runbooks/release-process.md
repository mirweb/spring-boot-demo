# Release Process

## Before release

- Ensure `CHANGELOG.md` reflects the pending changes.
- Update project version metadata as needed.
- Verify documentation under `docs/` still matches the implemented architecture and workflows.

## Release steps

1. Commit the release changes with a Conventional Commit message when appropriate.
2. Create the release commit and Git tag.
3. Merge the release branch back to `main` if the release was prepared on a feature branch.
4. Push commits and tags to the primary remote.

## After release

- Move the released changelog entries out of `Unreleased`.
- Keep ADRs and architecture docs current for any follow-up changes.
