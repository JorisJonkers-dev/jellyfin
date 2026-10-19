# jellyfin

[Jellyfin](https://jellyfin.org) and [Seerr](https://github.com/seerr-team/seerr)
(jellyseerr) as the estate runs them: the upstream images, run as `deploy`
(1000:1000) under a read-only root filesystem. deploy-kit delivers them as the
Project `jellyfin`.

## What the images change

- **jellyfin:** names `USER 1000:1000` and clears every setuid and setgid bit.
  The upstream image already reads its paths from `JELLYFIN_*` variables and
  runs as any user.
- **jellyseerr:** names `USER 1000:1000` and starts `node dist/index.js`
  directly, since `npm start` writes under a home directory the read-only root
  does not allow.

## Running it

`deploy/jellyfin.project.yml` and `deploy/env/` declare the Project:
- **media:** jellyfin reads the Platform document's `media` library at the
  paths its database already names, `/media/Series` and `/media/Films`.
- **GPU:** jellyfin locks the T1000 (`gpu: {class: transcode, model: [t1000]}`)
  and gets one share of it, under the runtime class the Platform names for
  nvidia.
- **config:** each app's config is a claim the platform's `file-backup` copies
  nightly. jellyfin's downloaded metadata (`/config/metadata`) and its
  transcodes (`/cache`) are claims of their own that are never backed up.

jellyseerr keeps its links to jellyfin, sonarr and radarr in its own settings.

Each release builds the images and publishes the Intent Fragment that the
estate composes. `scripts/smoke-test.sh` starts each image restricted and waits
until it serves; CI runs it on every change.

## Licence

This repository's own files are MIT: see [LICENSE](LICENSE). Jellyfin is
GPL-2.0 and Seerr is MIT.
