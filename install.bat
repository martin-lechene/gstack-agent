@echo off
setlocal enabledelayedexpansion

if "%~1"=="/?" goto help
if "%~1"=="--help" goto help

if not exist agent.yaml (
  echo Error: agent.yaml not found. Run this from the repository root.
  exit /b 1
)

echo Detecting existing agent support...
set "cursor_exists=no"
set "opencode_exists=no"
set "codex_exists=no"
set "antigravity_exists=no"
set "vscode_exists=no"
set "copilot_exists=no"
set "phpstorm_exists=no"
set "claude_exists=no"

if exist .cursor\rules\*.md (
  set "cursor_exists=yes"
)
if exist AGENTS.md (
  set "opencode_exists=yes"
)
if exist opencode.json (
  set "opencode_exists=yes"
)
if exist codex.json (
  set "codex_exists=yes"
)
if exist CODEX.md (
  set "codex_exists=yes"
)
if exist antigravity.json (
  set "antigravity_exists=yes"
)
if exist ANTIGRAVITY.md (
  set "antigravity_exists=yes"
)
if exist .vscode\agent.json (
  set "vscode_exists=yes"
)
if exist VSCODE.md (
  set "vscode_exists=yes"
)
if exist copilot.json (
  set "copilot_exists=yes"
)
if exist COPILOT.md (
  set "copilot_exists=yes"
)
if exist .phpstorm\junie.json (
  set "phpstorm_exists=yes"
)
if exist PHPSTORM.md (
  set "phpstorm_exists=yes"
)
if exist .claude\skills\ (
  set "claude_exists=yes"
)

echo Cursor:   %cursor_exists%
echo OpenCode: %opencode_exists%
echo Codex:    %codex_exists%
echo Antigravity: %antigravity_exists%
echo VS Code:  %vscode_exists%
echo Copilot:  %copilot_exists%
echo PhpStorm: %phpstorm_exists%
echo Claude:   %claude_exists%

echo.
set "recommended=Claude"
if "%cursor_exists%"=="yes" (
  set "recommended=Cursor"
) else if "%opencode_exists%"=="yes" (
  set "recommended=OpenCode"
) else if "%codex_exists%"=="yes" (
  set "recommended=Codex"
) else if "%antigravity_exists%"=="yes" (
  set "recommended=Antigravity"
) else if "%vscode_exists%"=="yes" (
  set "recommended=VSCode"
) else if "%copilot_exists%"=="yes" (
  set "recommended=Copilot"
) else if "%phpstorm_exists%"=="yes" (
  set "recommended=PhpStorm"
)

echo Recommended target based on detection: %recommended%

echo.

echo Choose installation target:
echo   1) Cursor support (.cursor\rules\)
echo   2) OpenCode support (AGENTS.md + opencode.json)
echo   3) Codex support (CODEX.md + codex.json)
echo   4) Antigravity support (ANTIGRAVITY.md + antigravity.json)
echo   5) VS Code support (.vscode\agent.json)
echo   6) Copilot support (COPILOT.md + copilot.json)
echo   7) PhpStorm Junie support (.phpstorm\junie.json)
echo   8) Claude default (use agent.yaml)
set "default=8"
if "%recommended%"=="Cursor" set "default=1"
if "%recommended%"=="OpenCode" set "default=2"
if "%recommended%"=="Codex" set "default=3"
if "%recommended%"=="Antigravity" set "default=4"
if "%recommended%"=="VSCode" set "default=5"
if "%recommended%"=="Copilot" set "default=6"
if "%recommended%"=="PhpStorm" set "default=7"

if "%~1"=="cursor" set "choice=1"
if "%~1"=="opencode" set "choice=2"
if "%~1"=="codex" set "choice=3"
if "%~1"=="antigravity" set "choice=4"
if "%~1"=="vscode" set "choice=5"
if "%~1"=="copilot" set "choice=6"
if "%~1"=="phpstorm" set "choice=7"
if "%~1"=="claude" set "choice=8"
if not defined choice (
  set /p "choice=Select 1/2/3/4/5/6/7/8 [default %default%]: "
  if "%choice%"=="" set "choice=%default%"
)

if "%choice%"=="1" goto do_cursor
if "%choice%"=="2" goto do_opencode
if "%choice%"=="3" goto do_codex
if "%choice%"=="4" goto do_antigravity
if "%choice%"=="5" goto do_vscode
if "%choice%"=="6" goto do_copilot
if "%choice%"=="7" goto do_phpstorm
if "%choice%"=="8" goto do_claude

echo Invalid selection: %choice%
exit /b 1

:do_cursor
if not exist .cursor\rules mkdir .cursor\rules
if not exist .cursor\rules\gstack-agent.mdc (
  >.cursor\rules\gstack-agent.mdc echo ---
  >>.cursor\rules\gstack-agent.mdc echo description: "gstack-agent global identity and rules"
  >>.cursor\rules\gstack-agent.mdc echo alwaysApply: true
  >>.cursor\rules\gstack-agent.mdc echo ---
  >>.cursor\rules\gstack-agent.mdc echo.
  >>.cursor\rules\gstack-agent.mdc echo # gstack-agent
  >>.cursor\rules\gstack-agent.mdc echo.
  >>.cursor\rules\gstack-agent.mdc echo This file was created by install.bat. Review and update it for Cursor if needed.
  echo Created .cursor\rules\gstack-agent.mdc
) else (
  echo Skipping .cursor\rules\gstack-agent.mdc (already exists)
)
if not exist .cursor\rules\browse.mdc (
  >.cursor\rules\browse.mdc echo ---
  >>.cursor\rules\browse.mdc echo description: "Browser skill rules for gstack-agent"
  >>.cursor\rules\browse.mdc echo alwaysApply: false
  >>.cursor\rules\browse.mdc echo ---
  >>.cursor\rules\browse.mdc echo.
  >>.cursor\rules\browse.mdc echo # browse
  >>.cursor\rules\browse.mdc echo.
  >>.cursor\rules\browse.mdc echo Placeholder rule for the browser skill. Adjust this file for Cursor rule behavior.
  echo Created .cursor\rules\browse.mdc
) else (
  echo Skipping .cursor\rules\browse.mdc (already exists)
)
goto done

:do_opencode
if not exist AGENTS.md (
  >AGENTS.md echo # gstack-agent
  >>AGENTS.md echo.
  >>AGENTS.md echo Six opinionated workflow skills that turn your AI coding assistant into a team of specialists.
  >>AGENTS.md echo.
  >>AGENTS.md echo ## OpenCode helper
  >>AGENTS.md echo.
  >>AGENTS.md echo This file was created by install.bat. Review the agent instructions and skill descriptions for your OpenCode runtime.
  echo Created AGENTS.md
) else (
  echo Skipping AGENTS.md (already exists)
)
if not exist opencode.json (
  >opencode.json echo {
  >>opencode.json echo   "model": "anthropic/claude-opus-4-6",
  >>opencode.json echo   "provider": {
  >>opencode.json echo     "anthropic": {
  >>opencode.json echo       "npm": "@ai-sdk/anthropic"
  >>opencode.json echo     }
  >>opencode.json echo   }
  >>opencode.json echo }
  echo Created opencode.json
) else (
  echo Skipping opencode.json (already exists)
)
goto done

:do_codex
if not exist CODEX.md (
  >CODEX.md echo # gstack-agent Codex adapter
  >>CODEX.md echo.
  >>CODEX.md echo This file was created by install.bat. Review the Codex runtime instructions and adjust the configuration as needed.
  echo Created CODEX.md
) else (
  echo Skipping CODEX.md (already exists)
)
if not exist codex.json (
  >codex.json echo {
  >>codex.json echo   "model": "openai/codex",
  >>codex.json echo   "provider": {
  >>codex.json echo     "openai": {
  >>codex.json echo       "npm": "openai"
  >>codex.json echo     }
  >>codex.json echo   }
  >>codex.json echo }
  echo Created codex.json
) else (
  echo Skipping codex.json (already exists)
)
goto done

:do_antigravity
if not exist ANTIGRAVITY.md (
  >ANTIGRAVITY.md echo # gstack-agent Antigravity adapter
  >>ANTIGRAVITY.md echo.
  >>ANTIGRAVITY.md echo This file was created by install.bat. Review the Antigravity runtime instructions and adjust the configuration as needed.
  echo Created ANTIGRAVITY.md
) else (
  echo Skipping ANTIGRAVITY.md (already exists)
)
if not exist antigravity.json (
  >antigravity.json echo {
  >>antigravity.json echo   "model": "antigravity/latest",
  >>antigravity.json echo   "provider": {
  >>antigravity.json echo     "antigravity": {
  >>antigravity.json echo       "npm": "@antigravity/sdk"
  >>antigravity.json echo     }
  >>antigravity.json echo   }
  >>antigravity.json echo }
  echo Created antigravity.json
) else (
  echo Skipping antigravity.json (already exists)
)
goto done

:do_vscode
if not exist .vscode mkdir .vscode
if not exist VSCODE.md (
  >VSCODE.md echo # gstack-agent VS Code AI adapter
  >>VSCODE.md echo.
  >>VSCODE.md echo This file was created by install.bat. Review the VS Code runtime instructions and adjust the configuration as needed.
  echo Created VSCODE.md
) else (
  echo Skipping VSCODE.md (already exists)
)
if not exist .vscode\agent.json (
  >.vscode\agent.json echo {
  >>.vscode\agent.json echo   "model": "vscode/ai",
  >>.vscode\agent.json echo   "settings": {
  >>.vscode\agent.json echo     "extension": "GitHub.copilot"
  >>.vscode\agent.json echo   }
  >>.vscode\agent.json echo }
  echo Created .vscode\agent.json
) else (
  echo Skipping .vscode\agent.json (already exists)
)
goto done

:do_copilot
if not exist COPILOT.md (
  >COPILOT.md echo # gstack-agent Copilot adapter
  >>COPILOT.md echo.
  >>COPILOT.md echo This file was created by install.bat. Review the GitHub Copilot runtime instructions and adjust the configuration as needed.
  echo Created COPILOT.md
) else (
  echo Skipping COPILOT.md (already exists)
)
if not exist copilot.json (
  >copilot.json echo {
  >>copilot.json echo   "model": "github/copilot",
  >>copilot.json echo   "provider": {
  >>copilot.json echo     "github": {
  >>copilot.json echo       "npm": "@github/copilot"
  >>copilot.json echo     }
  >>copilot.json echo   }
  >>copilot.json echo }
  echo Created copilot.json
) else (
  echo Skipping copilot.json (already exists)
)
goto done

:do_phpstorm
if not exist .phpstorm mkdir .phpstorm
if not exist PHPSTORM.md (
  >PHPSTORM.md echo # gstack-agent PhpStorm Junie adapter
  >>PHPSTORM.md echo.
  >>PHPSTORM.md echo This file was created by install.bat. Review the PhpStorm Junie runtime instructions and adjust the configuration as needed.
  echo Created PHPSTORM.md
) else (
  echo Skipping PHPSTORM.md (already exists)
)
if not exist .phpstorm\junie.json (
  >.phpstorm\junie.json echo {
  >>.phpstorm\junie.json echo   "model": "junie/latest",
  >>.phpstorm\junie.json echo   "provider": {
  >>.phpstorm\junie.json echo     "phpstorm": {
  >>.phpstorm\junie.json echo       "notes": "PhpStorm Junie runtime adapter"
  >>.phpstorm\junie.json echo     }
  >>.phpstorm\junie.json echo   }
  >>.phpstorm\junie.json echo }
  echo Created .phpstorm\junie.json
) else (
  echo Skipping .phpstorm\junie.json (already exists)
)
goto done

:do_claude
echo Selected Claude default. No files were created.
goto done

:help
echo Usage: install.bat [cursor|opencode|codex|antigravity|vscode|copilot|phpstorm|claude]
echo.
echo If no option is supplied, the script will detect the best target and prompt interactively.
exit /b 0

:done
echo.
echo Summary:
echo   Cursor:      %cursor_exists%
echo   OpenCode:    %opencode_exists%
echo   Codex:       %codex_exists%
echo   Antigravity: %antigravity_exists%
echo   VS Code:     %vscode_exists%
echo   Copilot:     %copilot_exists%
echo   PhpStorm:    %phpstorm_exists%
echo   Claude:      %claude_exists%
echo.
echo Completed without overwriting existing files.
endlocal
