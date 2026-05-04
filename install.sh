#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

usage() {
  cat <<EOF
Usage: bash install.sh [--target cursor|opencode|claude] [--help]

Interactive installer for gstack-agent.

Options:
  --target <cursor|opencode|claude>  Create only the selected support files.
  --help                             Show this help message.
EOF
}

detect_support() {
  cursor_exists=false
  opencode_exists=false
  claude_exists=false

  if [ -d "$root/.cursor/rules" ] && ls "$root/.cursor/rules"/*.md >/dev/null 2>&1; then
    cursor_exists=true
  fi

  if [ -f "$root/AGENTS.md" ] || [ -f "$root/opencode.json" ]; then
    opencode_exists=true
  fi

  if [ -d "$root/.claude/skills" ]; then
    claude_exists=true
  fi
}

recommended_target() {
  if [ "$cursor_exists" = true ]; then
    echo cursor
  elif [ "$opencode_exists" = true ]; then
    echo opencode
  else
    echo claude
  fi
}

prompt_choice() {
  local default_choice=$1
  read -r -p "Select 1/2/3 [default ${default_choice}]: " choice
  choice="${choice:-${default_choice}}"
  echo "$choice"
}

create_cursor() {
  mkdir -p "$root/.cursor/rules"
  if [ ! -f "$root/.cursor/rules/gstack-agent.mdc" ]; then
    cat > "$root/.cursor/rules/gstack-agent.mdc" <<'EOF'
---
description: "gstack-agent global identity and rules"
alwaysApply: true
---

# gstack-agent

This file was created by install.sh. Review and update it for Cursor if needed.
EOF
    echo "Created .cursor/rules/gstack-agent.mdc"
  else
    echo "Skipping .cursor/rules/gstack-agent.mdc (already exists)"
  fi

  if [ ! -f "$root/.cursor/rules/browse.mdc" ]; then
    cat > "$root/.cursor/rules/browse.mdc" <<'EOF'
---
description: "Browser skill rules for gstack-agent"
alwaysApply: false
---

# browse

Placeholder rule for the browser skill. Adjust this file for Cursor rule behavior.
EOF
    echo "Created .cursor/rules/browse.mdc"
  else
    echo "Skipping .cursor/rules/browse.mdc (already exists)"
  fi
}

create_opencode() {
  if [ ! -f "$root/AGENTS.md" ]; then
    cat > "$root/AGENTS.md" <<'EOF'
# gstack-agent

Six opinionated workflow skills that turn your AI coding assistant into a team of specialists.

## OpenCode helper

This file was created by install.sh. Review the agent instructions and skill descriptions for your OpenCode runtime.
EOF
    echo "Created AGENTS.md"
  else
    echo "Skipping AGENTS.md (already exists)"
  fi

  if [ ! -f "$root/opencode.json" ]; then
    cat > "$root/opencode.json" <<'EOF'
{
  "model": "anthropic/claude-opus-4-6",
  "provider": {
    "anthropic": {
      "npm": "@ai-sdk/anthropic"
    }
  }
}
EOF
    echo "Created opencode.json"
  else
    echo "Skipping opencode.json (already exists)"
  fi
}

if [ "${1:-}" = "--help" ] || [ "${1:-}" = "-h" ]; then
  usage
  exit 0
fi

if [ ! -f "$root/agent.yaml" ]; then
  echo "Error: agent.yaml not found. Run this script from the repository root."
  exit 1
fi

detect_support

echo "Detected existing adapter support:"
echo "  Cursor:   $([ "$cursor_exists" = true ] && echo yes || echo no)"
echo "  OpenCode: $([ "$opencode_exists" = true ] && echo yes || echo no)"
echo "  Claude:   $([ "$claude_exists" = true ] && echo yes || echo no)"

echo
recommended="$(recommended_target)"
echo "Recommended target: $recommended"
echo

if [ "${1:-}" = "--target" ]; then
  if [ -z "${2:-}" ]; then
    echo "Error: --target requires a value."
    usage
    exit 1
  fi
  case "$2" in
    cursor|opencode|claude)
      target="$2"
      ;;
    *)
      echo "Error: invalid target '$2'. Use cursor, opencode, or claude."
      usage
      exit 1
      ;;
  esac
else
  echo "Choose installation target:"
  echo "  1) Cursor support (.cursor/rules/)"
  echo "  2) OpenCode support (AGENTS.md + opencode.json)"
  echo "  3) Claude default (use agent.yaml)"
  choice=$(prompt_choice "$([ "$recommended" = "cursor" ] && echo 1 || { [ "$recommended" = "opencode" ] && echo 2 || echo 3; })")
  case "$choice" in
    1)
      target=cursor
      ;;
    2)
      target=opencode
      ;;
    3)
      target=claude
      ;;
    *)
      echo "Invalid selection: $choice"
      exit 1
      ;;
  esac
fi

echo "Selected target: $target"

echo
case "$target" in
  cursor)
    create_cursor
    ;;
  opencode)
    create_opencode
    ;;
  claude)
    echo "Selected Claude default. No files were created."
    ;;
esac

echo
cat <<EOF
Summary:
  Cursor support:   $cursor_exists
  OpenCode support: $opencode_exists
  Claude support:   $claude_exists
EOF

echo "Installation helper completed without overwriting existing files."
