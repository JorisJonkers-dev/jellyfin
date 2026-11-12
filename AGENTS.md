# Agents

Guidance for any coding agent working in this repository.

The agent contract is [CLAUDE.md](CLAUDE.md); the [estate contract](https://github.com/JorisJonkers-dev/workspace/blob/main/CLAUDE.md) applies too.

## Build and test

```sh
shellcheck scripts/*.sh
docker build -t jellyfin:ci jellyfin
scripts/smoke-test.sh jellyfin:ci
```

These mirror `.github/workflows/ci.yml`. The image is defined in `jellyfin/Dockerfile`; the Project is declared under `deploy/`.
