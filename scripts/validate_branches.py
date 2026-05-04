from pathlib import Path
import subprocess
import sys

ROOT = Path(__file__).resolve().parent.parent
BRANCHES = ["main", "claude", "cursor", "opencode", "codex", "antigravity", "vscode", "copilot", "phpstorm"]


def run(cmd, **kwargs):
    result = subprocess.run(cmd, cwd=ROOT, text=True, capture_output=True, **kwargs)
    if result.returncode != 0 and kwargs.get("check", True):
        print(result.stdout, end="")
        print(result.stderr, end="", file=sys.stderr)
        raise subprocess.CalledProcessError(result.returncode, cmd)
    return result


def git(*args, check=True):
    return run(["git", *args], check=check)


def current_branch():
    result = git("rev-parse", "--abbrev-ref", "HEAD")
    return result.stdout.strip()


def current_commit():
    result = git("rev-parse", "HEAD")
    return result.stdout.strip()


def ensure_clean_worktree():
    status = git("status", "--porcelain", check=True).stdout.strip()
    if status:
        raise SystemExit("Working tree is dirty. Commit or stash changes before running validation.")


def branch_exists(branch):
    result = git("branch", "--list", branch, check=True)
    return bool(result.stdout.strip())


def remote_branch_exists(branch):
    result = git("ls-remote", "--heads", "origin", branch, check=True)
    return bool(result.stdout.strip())


def checkout_branch(branch):
    if branch_exists(branch):
        git("checkout", branch)
        return True
    if remote_branch_exists(branch):
        git("checkout", "-b", branch, f"origin/{branch}")
        return True
    return False


def fetch_origin_refs():
    try:
        run(["git", "fetch", "--prune", "--no-tags", "origin", "+refs/heads/*:refs/remotes/origin/*"])
    except subprocess.CalledProcessError:
        print("Warning: Unable to fetch origin refs; continuing with available local references.")


def file_exists(path):
    return (ROOT / path).exists()


def read_file(path):
    return (ROOT / path).read_text(encoding="utf-8")


def validate_branch(branch):
    issues = []
    if not file_exists("agent.yaml"):
        issues.append("Missing agent.yaml")
    if branch == "cursor":
        if not file_exists(".cursor/rules/gstack-agent.mdc"):
            issues.append("Missing .cursor/rules/gstack-agent.mdc")
        if not any((ROOT / ".cursor/rules").glob("*.md")):
            issues.append("No Cursor rule files found under .cursor/rules/")
    if branch == "opencode":
        if not file_exists("AGENTS.md"):
            issues.append("Missing AGENTS.md")
        if not file_exists("opencode.json"):
            issues.append("Missing opencode.json")
    if branch == "codex":
        if not file_exists("CODEX.md"):
            issues.append("Missing CODEX.md")
        if not file_exists("codex.json"):
            issues.append("Missing codex.json")
    if branch == "antigravity":
        if not file_exists("ANTIGRAVITY.md"):
            issues.append("Missing ANTIGRAVITY.md")
        if not file_exists("antigravity.json"):
            issues.append("Missing antigravity.json")
    if branch == "vscode":
        if not file_exists("VSCODE.md"):
            issues.append("Missing VSCODE.md")
        if not file_exists(".vscode/agent.json"):
            issues.append("Missing .vscode/agent.json")
    if branch == "copilot":
        if not file_exists("COPILOT.md"):
            issues.append("Missing COPILOT.md")
        if not file_exists("copilot.json"):
            issues.append("Missing copilot.json")
    if branch == "phpstorm":
        if not file_exists("PHPSTORM.md"):
            issues.append("Missing PHPSTORM.md")
        if not file_exists(".phpstorm/junie.json"):
            issues.append("Missing .phpstorm/junie.json")
    if branch == "main":
        if not file_exists("install.sh") or not file_exists("install.bat"):
            issues.append("Install helpers missing for main branch")
    if not file_exists("README.md"):
        issues.append("Missing README.md")
    else:
        content = read_file("README.md")
        if "Branch adaptation matrix" not in content:
            issues.append("README.md missing branch adaptation matrix")
        if "Install helper" not in content:
            issues.append("README.md missing Install helper section")
    return issues


def validate_shell_scripts():
    script = ROOT / "install.sh"
    if script.exists():
        run(["bash", "-n", str(script)])


def validate_python_scripts():
    script = ROOT / "scripts/validate_branches.py"
    if script.exists():
        run([sys.executable, "-m", "py_compile", str(script)])


def main():
    ensure_clean_worktree()
    original = current_branch()
    original_commit = current_commit()
    print(f"Starting validation from branch: {original} ({original_commit})")
    fetch_origin_refs()

    errors = []
    try:
        for branch in BRANCHES:
            print(f"\nValidating branch: {branch}")
            if not (branch_exists(branch) or remote_branch_exists(branch)):
                print(f"Skipping unavailable branch: {branch}")
                continue
            if not checkout_branch(branch):
                print(f"Unable to check out branch {branch}; skipping.")
                continue
            issues = validate_branch(branch)
            if issues:
                print("Issues found:")
                for issue in issues:
                    print(f"  - {issue}")
                errors.extend([f"{branch}: {issue}" for issue in issues])
            else:
                print("No issues found.")
        print("\nValidating helper scripts syntax")
        validate_shell_scripts()
        validate_python_scripts()
    finally:
        if original == "HEAD":
            git("checkout", "--detach", original_commit)
        else:
            if not checkout_branch(original):
                git("checkout", "--detach", original_commit)
        print(f"\nRestored original state: {original} ({original_commit})")
    if errors:
        raise SystemExit(f"Validation failed with {len(errors)} issue(s).")
    print("\nAll checks passed.")


if __name__ == "__main__":
    main()
