# Agent contract

The estate-wide conventions live in one place and are **not duplicated here**:

**https://github.com/JorisJonkers-dev/workspace/blob/main/CLAUDE.md**

Read it before doing anything non-trivial in this repository. It covers the
things that most often go wrong, including:

- **Pull request labels.** The estate uses a prefixed taxonomy — `type:`,
  `area:`, `component:`, `priority:`, `status:`. Plain `bug` / `enhancement` /
  `documentation` do **not** exist, and `gh pr create` fails with
  `'bug' not found`. Run `gh label list --repo <owner>/<repo>` once before
  passing `--label`.
- **Verify the value, not the command.** An exit code, a `Ready` condition or
  an accepted object is not evidence that a consumer sees what you intended.
- **Tests.** Each test checks one behaviour and is named as that behaviour; tests run with
  no retries, and a flaky test is fixed or quarantined with an issue for at most 14 days.
  The standard is
  [docs/testing-standards.md](https://github.com/JorisJonkers-dev/workspace/blob/main/docs/testing-standards.md).
- Traps around workflow runs, `zsh` word-splitting, and detached submodule
  HEADs.

Duplicating that content into every repository guarantees the copies drift, so
this file stays a pointer. Add repo-specific guidance below.

---

## This repository

The image must keep running as 1000:1000 (`deploy`, which owns the media library and this config)
under a read-only root filesystem: deploy-kit refuses any Process that cannot (`E_HARDENING_UNMET`).
Keep jellyfin's media mounts at the paths its database names (`/media/Series`, `/media/Films`). Run
`scripts/smoke-test.sh` after any change to the `Dockerfile`.

The version is jellyfin's own, read from the `FROM` tag: there is no release-please, and a change
that keeps the `FROM` tag is released with the next jellyfin version.
