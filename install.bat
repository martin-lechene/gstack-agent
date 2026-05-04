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
if exist .claude\skills\ (
  set "claude_exists=yes"
)

echo Cursor:   %cursor_exists%
echo OpenCode: %opencode_exists%
echo Claude:   %claude_exists%

echo.
set "recommended=Claude"
if "%cursor_exists%"=="yes" (
  set "recommended=Cursor"
) else if "%opencode_exists%"=="yes" (
  set "recommended=OpenCode"
)

echo Recommended target based on detection: %recommended%

echo.

echo Choose installation target:
echo   1) Cursor support (.cursor\rules\)
echo   2) OpenCode support (AGENTS.md + opencode.json)
echo   3) Claude default (use agent.yaml)
set "default=3"
if "%recommended%"=="Cursor" set "default=1"
if "%recommended%"=="OpenCode" set "default=2"

if "%~1"=="cursor" set "choice=1"
if "%~1"=="opencode" set "choice=2"
if "%~1"=="claude" set "choice=3"
if not defined choice (
  set /p "choice=Select 1/2/3 [default %default%]: "
  if "%choice%"=="" set "choice=%default%"
)

if "%choice%"=="1" goto do_cursor
if "%choice%"=="2" goto do_opencode
if "%choice%"=="3" goto do_claude

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

:do_claude
echo Selected Claude default. No files were created.
goto done

:help
echo Usage: install.bat [cursor|opencode|claude]
echo.
echo If no option is supplied, the script will detect the best target and prompt interactively.
exit /b 0

:done
echo.
echo Completed without overwriting existing files.
endlocal
