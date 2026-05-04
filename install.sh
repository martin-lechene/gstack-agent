#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

usage() {
  cat <<EOF
Usage: bash install.sh [--target cursor|opencode|codex|antigravity|vscode|copilot|phpstorm|claude] [--help]

Interactive installer for gstack-agent.

Options:
  --target <cursor|opencode|codex|antigravity|vscode|copilot|phpstorm|claude>
                                    Create only the selected support files.
  --help                             Show this help message.
EOF
}

detect_support() {
  cursor_exists=false
  opencode_exists=false
  codex_exists=false
  antigravity_exists=false
  vscode_exists=false
  copilot_exists=false
  phpstorm_exists=false
  claude_exists=false

  if [ -d "$root/.cursor/rules" ] && ls "$root/.cursor/rules"/*.md >/dev/null 2>&1; then
    cursor_exists=true
  fi

  if [ -f "$root/AGENTS.md" ] || [ -f "$root/opencode.json" ]; then
    opencode_exists=true
  fi

  if [ -f "$root/codex.json" ] || [ -f "$root/CODEX.md" ]; then
    codex_exists=true
  fi

  if [ -f "$root/antigravity.json" ] || [ -f "$root/ANTIGRAVITY.md" ]; then
    antigravity_exists=true
  fi

  if [ -d "$root/.vscode" ] || [ -f "$root/VSCODE.md" ]; then
    vscode_exists=true
  fi

  if [ -f "$root/copilot.json" ] || [ -f "$root/COPILOT.md" ]; then
    copilot_exists=true
  fi

  if [ -f "$root/.phpstorm/junie.json" ] || [ -f "$root/PHPSTORM.md" ]; then
    phpstorm_exists=true
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
  elif [ "$codex_exists" = true ]; then
    echo codex
  elif [ "$antigravity_exists" = true ]; then
    echo antigravity
  elif [ "$vscode_exists" = true ]; then
    echo vscode
  elif [ "$copilot_exists" = true ]; then
    echo copilot
  elif [ "$phpstorm_exists" = true ]; then
    echo phpstorm
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

create_codex() {
  if [ ! -f "$root/CODEX.md" ]; then
    cat > "$root/CODEX.md" <<'EOF'
# gstack-agent Codex adapter

This file was created by install.sh. Review the Codex runtime instructions and adjust the configuration as needed.
EOF
    echo "Created CODEX.md"
  else
    echo "Skipping CODEX.md (already exists)"
  fi

  if [ ! -f "$root/codex.json" ]; then
    cat > "$root/codex.json" <<'EOF'
{
  "model": "openai/codex",
  "provider": {
    "openai": {
      "npm": "openai"
    }
  }
}
EOF
    echo "Created codex.json"
  else
    echo "Skipping codex.json (already exists)"
  fi
}

create_antigravity() {
  if [ ! -f "$root/ANTIGRAVITY.md" ]; then
    cat > "$root/ANTIGRAVITY.md" <<'EOF'
# gstack-agent Antigravity adapter

This file was created by install.sh. Review the Antigravity runtime instructions and adjust the configuration as needed.
EOF
    echo "Created ANTIGRAVITY.md"
  else
    echo "Skipping ANTIGRAVITY.md (already exists)"
  fi

  if [ ! -f "$root/antigravity.json" ]; then
    cat > "$root/antigravity.json" <<'EOF'
{
  "model": "antigravity/latest",
  "provider": {
    "antigravity": {
      "npm": "@antigravity/sdk"
    }
  }
}
EOF
    echo "Created antigravity.json"
  else
    echo "Skipping antigravity.json (already exists)"
  fi
}

create_vscode() {
  mkdir -p "$root/.vscode"
  if [ ! -f "$root/VSCODE.md" ]; then
    cat > "$root/VSCODE.md" <<'EOF'
# gstack-agent VS Code AI adapter

This file was created by install.sh. Review the VS Code runtime instructions and adjust the configuration as needed.
EOF
    echo "Created VSCODE.md"
  else
    echo "Skipping VSCODE.md (already exists)"
  fi

  if [ ! -f "$root/.vscode/agent.json" ]; then
    cat > "$root/.vscode/agent.json" <<'EOF'
{
  "model": "vscode/ai",
  "settings": {
    "extension": "GitHub.copilot"
  }
}
EOF
    echo "Created .vscode/agent.json"
  else
    echo "Skipping .vscode/agent.json (already exists)"
  fi
}

create_copilot() {
  if [ ! -f "$root/COPILOT.md" ]; then
    cat > "$root/COPILOT.md" <<'EOF'
# gstack-agent Copilot adapter

This file was created by install.sh. Review the GitHub Copilot runtime instructions and adjust the configuration as needed.
EOF
    echo "Created COPILOT.md"
  else
    echo "Skipping COPILOT.md (already exists)"
  fi

  if [ ! -f "$root/copilot.json" ]; then
    cat > "$root/copilot.json" <<'EOF'
{
  "model": "github/copilot",
  "provider": {
    "github": {
      "npm": "@github/copilot"
    }
  }
}
EOF
    echo "Created copilot.json"
  else
    echo "Skipping copilot.json (already exists)"
  fi
}

create_phpstorm() {
  mkdir -p "$root/.phpstorm"
  if [ ! -f "$root/PHPSTORM.md" ]; then
    cat > "$root/PHPSTORM.md" <<'EOF'
# gstack-agent PhpStorm Junie adapter

This file was created by install.sh. Review the PhpStorm Junie runtime instructions and adjust the configuration as needed.
EOF
    echo "Created PHPSTORM.md"
  else
    echo "Skipping PHPSTORM.md (already exists)"
  fi

  if [ ! -f "$root/.phpstorm/junie.json" ]; then
    cat > "$root/.phpstorm/junie.json" <<'EOF'
{
  "model": "junie/latest",
  "provider": {
    "phpstorm": {
      "notes": "PhpStorm Junie runtime adapter"
    }
  }
}
EOF
    echo "Created .phpstorm/junie.json"
  else
    echo "Skipping .phpstorm/junie.json (already exists)"
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
    cursor|opencode|codex|antigravity|vscode|copilot|phpstorm|claude)
      target="$2"
      ;;
    *)
      echo "Error: invalid target '$2'. Use cursor, opencode, codex, antigravity, vscode, copilot, phpstorm, or claude."
      usage
      exit 1
      ;;
  esac
else
  echo "Choose installation target:"
  echo "  1) Cursor support (.cursor/rules/)"
  echo "  2) OpenCode support (AGENTS.md + opencode.json)"
  echo "  3) Codex support (CODEX.md + codex.json)"
  echo "  4) Antigravity support (ANTIGRAVITY.md + antigravity.json)"
  echo "  5) VS Code support (.vscode/agent.json)"
  echo "  6) Copilot support (COPILOT.md + copilot.json)"
  echo "  7) PhpStorm Junie support (.phpstorm/junie.json)"
  echo "  8) Claude default (use agent.yaml)"
  choice=$(prompt_choice "$([ "$recommended" = "cursor" ] && echo 1 || { [ "$recommended" = "opencode" ] && echo 2 || { [ "$recommended" = "codex" ] && echo 3 || { [ "$recommended" = "antigravity" ] && echo 4 || { [ "$recommended" = "vscode" ] && echo 5 || { [ "$recommended" = "copilot" ] && echo 6 || { [ "$recommended" = "phpstorm" ] && echo 7 || echo 8; } } } } } } ) )")
  case "$choice" in
    1)
      target=cursor
      ;;
    2)
      target=opencode
      ;;
    3)
      target=codex
      ;;
    4)
      target=antigravity
      ;;
    5)
      target=vscode
      ;;
    6)
      target=copilot
      ;;
    7)
      target=phpstorm
      ;;
    8)
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
  codex)
    create_codex
    ;;
  antigravity)
    create_antigravity
    ;;
  vscode)
    create_vscode
    ;;
  copilot)
    create_copilot
    ;;
  phpstorm)
    create_phpstorm
    ;;
  claude)
    echo "Selected Claude default. No files were created."
    ;;
esac

echo
cat <<EOF
Summary:
  Cursor support:      $cursor_exists
  OpenCode support:    $opencode_exists
  Codex support:       $codex_exists
  Antigravity support: $antigravity_exists
  VS Code support:     $vscode_exists
  Copilot support:     $copilot_exists
  PhpStorm support:    $phpstorm_exists
  Claude support:      $claude_exists
EOF

echo "Installation helper completed without overwriting existing files."
