# Release Process

## Before release

- Ensure `CHANGELOG.md` reflects the pending changes.
- Update project version metadata as needed.
- Verify documentation under `docs/` still matches the implemented architecture and workflows.
- Ensure the GitLab CI pipeline is green for the relevant branch or merge request.
- Check GitLab test reports when a CI validation job fails instead of relying on raw logs alone.
- If infrastructure code changed, verify the OpenTofu validation job passes and confirm whether OCI plan/apply credentials or state settings need updates.

## Release steps

1. Commit the release changes with a Conventional Commit message when appropriate.
2. Create the release commit and Git tag.
3. Merge the release branch back to `main` if the release was prepared on a feature branch.
4. Push commits and tags to the primary remote.
5. Verify the tag pipeline publishes an image to the GitLab Container Registry as `$CI_REGISTRY_IMAGE:$CI_COMMIT_TAG`.

## After release

- Move the released changelog entries out of `Unreleased`.
- Confirm the release image is available in the project container registry for deployment or manual validation.
- Keep ADRs and architecture docs current for any follow-up changes.
- Review whether the infrastructure workflow docs still match the active OCI shape, region, and GitLab state setup.
