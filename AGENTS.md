# AGENTS.md

Notes for coding agents (and humans) working on this repository. Read this first.

## Setup and commands

```bash
uv sync --all-groups   # dev environment
uvx prek install       # git hooks

just format      # uvx ruff format
just lint        # uvx ruff check
just typecheck   # uvx ty check
just test        # uv run pytest
```

- **Tests**: read [`TESTING.md`](TESTING.md) before writing or reviewing tests (what to test, what not to, where to fake).
- **pytest** runs with `filterwarnings = error` (except `UserWarning` / `DeprecationWarning`), so a new warning fails the tests.
- **ty**: compare the diagnostics on the files you touch before and after a change, rather than expecting a clean run.
- Run `just test` locally before every PR, and check which CI jobs actually ran (see `.github/workflows/`) before relying on them.

## Communication & Commits

- **Branch from `main`**, with a prefix: `feature/` (or `feat/`), `fix/`, `docs/`, `test/`, `chore/`, `refactor/`, `config/`.
- **Commit messages**: Conventional Commits (`feat(api): ...`, `fix(cli): ...`). No AI attribution lines.
- When an agent creates a PR or issue, add the agent-generated label.
- Comments by agents on PRs/issues must begin with 🤖, unless the user has explicitly approved the exact text. This only applies to comments — never use a 🤖 marker in a commit message or PR/issue body.
- When using gh to inspect issues or PRs, use the --json <fields> flag or an explicit narrowing flag, such as --comments. Avoid using the plain gh issue view or gh pr view flags.
- **Every PR updates `CHANGELOG.md`** under `## Unreleased` ([Keep a Changelog](https://keepachangelog.com/): one `### Added` / `### Changed` / `### Fixed` / `### Removed` / `### Security` heading each, no blank lines between bullets, bullets start with `**Area**:`). Two PRs that both add a bullet to the same list conflict; resolve by keeping both bullets.
- **PRs are squash-merged** with the branch deleted (`gh pr merge <n> --squash --delete-branch`). PR descriptions end with a test plan saying what was run and what wasn't.
- Releases follow [`RELEASE.md`](RELEASE.md) (`uv version --bump ...`, move `Unreleased` into `## vX.Y.Z - date`).
