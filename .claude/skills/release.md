---
name: release
description: Cut a new release — finalizes CHANGELOG.md, commits, tags, and pushes. Usage: /release <version> (e.g. /release 0.7.0)
argument-hint: <version>  e.g. 0.7.0
---

Cut a release for version $ARGUMENTS.

## Steps

1. **Validate input**
   - The argument must be a valid SemVer version (e.g. `0.7.0`). If missing or malformed, stop and ask the user.
   - Confirm the current branch is `main`. If not, warn the user and ask whether to continue.

2. **Check CHANGELOG.md**
   - Read `CHANGELOG.md`.
   - If there are no entries under `## [Unreleased]`, stop and tell the user there is nothing to release.

3. **Finalize CHANGELOG.md**
   - Replace the `## [Unreleased]` heading with `## [$ARGUMENTS] - YYYY-MM-DD` (use today's date).
   - Add a new empty `## [Unreleased]` section at the top, above the new release section.
   - Do not alter any existing release entries.
   - Do NOT touch `pom.xml` — the version is controlled via `-Drevision=$CI_COMMIT_TAG` in CI.

4. **Commit**
   - Stage only `CHANGELOG.md`.
   - Commit message (Conventional Commits):
     ```
     chore(release): bump version to $ARGUMENTS
     ```

5. **Tag**
   - Create an annotated git tag: `git tag -a $ARGUMENTS -m "Release $ARGUMENTS"`
   - Tags must NOT have a `v` prefix.

6. **Push**
   - Push commit and tag: `git push origin main $ARGUMENTS`

7. **Summary**
   - Print the commit hash and tag.
