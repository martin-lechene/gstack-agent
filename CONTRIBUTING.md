# Contributing to gstack-agent

Thank you for contributing to `gstack-agent`. This repository is product-ready with a focus on quality, branch adaptation, and clear release discipline.

## Getting started

1. Read the `README.md` for the overall workflow.
2. Use `bash install.sh` on Linux/macOS or `install.bat` on Windows to initialize adapter helpers.
3. If you change the manifest or skills, run the validation suite:

```bash
python scripts/validate_branches.py
```

## Versioning

- The repository uses semantic versioning via the `VERSION` file.
- Tag releases with `git tag -a vX.Y.Z -m "Release vX.Y.Z"`.
- Push tags with `git push origin --tags`.

## Branch workflow

- `main` is the canonical product-ready branch.
- `claude`, `cursor`, `opencode`, `codex`, `antigravity`, `vscode`, `copilot`, and `phpstorm` are adaptation branches for the target runtimes.
- Changes to `main` should be compatible with all branch artifacts whenever possible.

## Issues and pull requests

- Use the provided GitHub issue templates for bug reports and feature requests.
- For pull requests, use the PR template and include a checklist of validation steps.
- Keep changes small and focused.

## Testing

This repository includes a validation workflow that checks branch artifacts and helper syntaxes.
- Local validation: `python scripts/validate_branches.py`
- CI validation: GitHub Actions runs on push and pull requests.
