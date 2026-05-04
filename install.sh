#!/usr/bin/env bash
set -euo pipefail

root="$(pwd)"
if [ ! -f "$root/agent.yaml" ]; then
  echo "Error: agent.yaml not found. Run this script from the repository root."
  exit 1
fi

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

echo "Detected existing agent support:"
echo "  Cursor:   $([ "$cursor_exists" = true ] && echo yes || echo no)"
echo "  OpenCode: $([ "$opencode_exists" = true ] && echo yes || echo no)"
echo "  Claude:   $([ "$claude_exists" = true ] && echo yes || echo no)"

recommended="Claude"
if [ "$cursor_exists" = true ]; then
  recommended="Cursor"
elif [ "$opencode_exists" = true ]; then
  recommended="OpenCode"
fi

echo
printf "Recommended target based on detection: %s\n" "$recommended"
echo

echo "Choose installation target:"
echo "  1) Cursor support (.cursor/rules/)"
echo "  2) OpenCode support (AGENTS.md + opencode.json)"
echo "  3) Claude default (use agent.yaml)"
read -r -p "Select 1/2/3 [default $( [ "$recommended" = "Cursor" ] && echo 1 || { [ "$recommended" = "OpenCode" ] && echo 2 || echo 3; } )]: " choice
choice="${choice:-$( [ "$recommended" = "Cursor" ] && echo 1 || { [ "$recommended" = "OpenCode" ] && echo 2 || echo 3; } )}"

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

case "$choice" in
  1)
    echo "Selected Cursor support."
    create_cursor
    ;;
  2)
    echo "Selected OpenCode support."
    create_opencode
    ;;
  3)
    echo "Selected Claude default. No files were created."
    ;;
  *)
    echo "Invalid selection: $choice"
    exit 1
    ;;
esac

echo
cat <<EOF
Summary:
  Cursor support:   $cursor_exists
  OpenCode support: $opencode_exists
  Claude support:   $claude_exists
EOF

echo "Completed without overwriting existing files."
