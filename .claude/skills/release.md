---
name: release
description: Cut a new release — bumps pom.xml version, finalizes CHANGELOG.md, commits, and tags. Usage: /release <version> (e.g. /release 0.7.0)
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

3. **Bump version in pom.xml**
   - In `pom.xml`, update the top-level `<version>` element (the first one, inside `<project>`) to the new version.
   - Do NOT change dependency or plugin versions.

4. **Finalize CHANGELOG.md**
   - Replace the `## [Unreleased]` heading with `## [$ARGUMENTS] - YYYY-MM-DD` (use today's date).
   - Add a new empty `## [Unreleased]` section at the top, above the new release section.
   - Do not alter any existing release entries.

5. **Commit**
   - Stage only `pom.xml` and `CHANGELOG.md`.
   - Commit message (Conventional Commits):
     ```
     chore(release): bump version to $ARGUMENTS
     ```

6. **Tag**
   - Create an annotated git tag: `git tag -a $ARGUMENTS -m "Release $ARGUMENTS"`
   - Tags must NOT have a `v` prefix.

7. **Summary**
   - Print the commit hash and tag.
   - Remind the user to push: `git push origin main $ARGUMENTS`
