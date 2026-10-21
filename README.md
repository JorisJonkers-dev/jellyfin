# jellyfin

[Jellyfin](https://jellyfin.org) as the estate runs it: the upstream image, run
as `deploy` (1000:1000) under a read-only root filesystem. deploy-kit delivers
it as the Project `jellyfin`.

## What the image changes

`jellyfin/Dockerfile` names `USER 1000:1000` and clears every setuid and setgid
bit. The upstream image already reads its paths from `JELLYFIN_*` variables and
runs as any user.

## Versions

This repository releases its own semver, continuing from `v10.11.11`, the last
tag named after jellyfin. The jellyfin version the image ships is recorded
separately, as the images lock's `version` (JorisJonkers-dev/workspace#140), so
a fix to our configuration no longer waits for a jellyfin release. Renovate
opens a pull request for each update, as a `fix`, so release-please releases
it. A minor or patch update merges itself once `Pipeline Complete` passes; a
major release waits for approval on the Dependency Dashboard. Merging release-
please's pull request tags `vX.Y.Z`, which publishes the image and the Intent
Fragment.

## Running it

`deploy/jellyfin.project.yml` and `deploy/env/` declare the Project:
- **media:** jellyfin reads the Platform document's `media` library at the
  paths its database already names, `/media/Series` and `/media/Films`.
- **GPU:** jellyfin locks the T1000 (`gpu: {class: transcode, model: [t1000]}`)
  and gets one share of it, under the runtime class the Platform names for
  nvidia.
- **config:** jellyfin's config is a claim the platform's `file-backup` copies
  nightly. Its downloaded metadata (`/config/metadata`) and its transcodes
  (`/cache`) are claims of their own that are never backed up.

`scripts/smoke-test.sh` starts the image restricted and waits until it serves;
CI runs it on every change.

## Licence

This repository's own files are MIT: see [LICENSE](LICENSE). Jellyfin is
GPL-2.0.
