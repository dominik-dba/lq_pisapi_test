REM Incremental SQLcl Project cycle (no LB diff/update-sql path)
REM USAGE: cycle.cmd 1.5 cycle

REM Correct order for your process:
REM 
REM 1. Create feature from main.
REM 2. Do DB changes + PROJECT export on feature.
REM      create table pis_storitve_pos.tmp_test2058 as select * from pis_storitve_pos.tmp_test2056;
REM 3. Commit feature.
REM 4. Create stage branch from feature (or move feature commits onto stage).
REM 5. Run PROJECT stage on stage branch.
REM 6. Review/commit stage outputs.
REM 7. Run PROJECT release -version 1.3.
REM 8. Merge stage into main.
REM 9. Tag and push

set REF_URL=jdbc:oracle:thin:@pngodb.src.si:1521/pngordn
set REF_USER=PIS_STORITVE_POS
set REF_PASS=PIS_STORITVE_POS
set TGT_URL=jdbc:oracle:thin:@ora26ai.src.si:1521/orclpdb
set TGT_USER=PIS_STORITVE_POS
set TGT_PASS=PIS_STORITVE_POS
SET LIQUIBASE_HOME=C:\Ant\liquibase\
SET LD_LIBRARY_PATH=C:\Oracle\product\instantclient_23_26;C:\Oracle\product\instantclient_23_26

@echo off
setlocal EnableExtensions EnableDelayedExpansion

set "ROOT=%~dp0"

cd /d "%ROOT%"

set "VERSION=%~1"
if "%VERSION%"=="" set "VERSION=1.1"

set "TICKET=%~2"
if "%TICKET%"=="" set "TICKET=cycle"

set "FEATURE_BRANCH=feature/PISAPI-%VERSION%-%TICKET%"
set "STAGE_BRANCH=stage/%VERSION%"
set "RELEASE_TAG=v%VERSION%"
set "ARTIFACT=artifact\PISAPI-%VERSION%.zip"
set "REMOTE_NAME="
set "LB_DIFF_FILE=lb_diff_%VERSION%.xml"
set "LB_DIFF_SQL=lb_diff_%VERSION%.sql"

git checkout main
git add .
git commit -m "NC"
git push
cd /d "%ROOT%"

call :preflight || goto :fail

echo ==========================================================
echo NEXT CYCLE RUNBOOK - VERSION %VERSION%
echo Feature branch: %FEATURE_BRANCH%
echo Stage branch:   %STAGE_BRANCH%
echo ==========================================================
echo.

echo [1/9] Create feature branch from main
git push

call :pull_main || goto :fail

git checkout -b %FEATURE_BRANCH% || goto :fail

echo.
echo Apply your schema/object changes in DEV now.
pause

echo ==========================================================
echo EXPORT
echo ==========================================================

echo [2/9] PROJECT export from DEV
sql26 -name dev @src/scripts/during/next_cycle_project_export.sql || goto :fail
echo.


REM echo manually remove dropped objects from src\database
REM **************** DROP TABLE *********************
REM 
REM Remove its tracked source files from repo folders:
REM src/database/pis_storitve_pos/tables/<old_table>.sql
REM related files if table-owned:
REM src/database/pis_storitve_pos/indexes/...
REM src/database/pis_storitve_pos/ref_constraints/...
REM src/database/pis_storitve_pos/object_grants/...
REM src/database/pis_storitve_app/synonyms/... (if applicable)
REM 
REM 		remove tmp_test2052 from C:\Install\Db\PISAPILQ2050\src\database\pis_storitve_pos
REM 
REM 		del C:\Install\Db\PISAPILQ2050\src\database\pis_storitve_pos\tmp_test2052.sql
REM 
REM [C:\Install\Db\PISAPILQ2050]git diff --name-only
REM 
REM [C:\Install\Db\PISAPILQ2050]git status --short --untracked-files=all
REM 		 D src/database/pis_storitve_pos/tables/tmp_test2052.sql
REM 		?? src/database/pis_storitve_pos/tables/tmp_test2053.sql
REM 
REM [C:\Install\Db\PISAPILQ2050]git add -A
REM warning: in the working copy of 'src/database/pis_storitve_pos/tables/tmp_test2053.sql', LF will be replaced by CRLF the next time Git touches it
REM 
REM ********************* DROP TABLE ********************

REM set VERSION=1.1
REM SET TICKET=cycle  
REM set "FEATURE_BRANCH=feature/PISAPI-%VERSION%-%TICKET%"
REM set "STAGE_BRANCH=stage/%VERSION%"
REM set "RELEASE_TAG=v%VERSION%"
REM set "ARTIFACT=artifact\PISAPI-%VERSION%.zip"


REM 3. Commit feature.


echo [3/9] Commit feature changes and merge to main
git add .
git commit -m "Feature %TICKET%: export project changes"
git checkout -b %STAGE_BRANCH% || goto :fail

echo ==========================================================
echo STAGE
echo ==========================================================

echo [4/9] PROJECT stage and commit release changelog

sql26 -name dev @src/scripts/during/next_cycle_project_stage.sql || goto :fail

git log --oneline --decorate --graph -n 10

git add .
git commit -m "Prepare release changelog %VERSION%"

REM dropajo se preko C:\Install\Db\PISAPILQ2050\dist\releases\next\release.changelog.xml
REM C:\Install\Db\PISAPILQ2050\dist\releases\next\pis_storitve_pos\tables\drop_old_table.sql

REM begin
REM   execute immediate 'drop table pis_storitve_pos.test_2066';
REM exception when others then
REM   null;
REM end;
REM /
REM 
REM begin
REM   execute immediate 'drop table pis_storitve_pos.tmp_test6';
REM exception when others then
REM   null;
REM end;
REM /
REM 
REM begin
REM   execute immediate 'drop table pis_storitve_pos.tmp_test2052';
REM exception when others then
REM   null;
REM end;
REM /

echo ==========================================================
echo RELEASE, GEN ARTIFACT
echo ==========================================================

echo [5/9] PROJECT release and artifact generation

sql26 -name dev @src/scripts/during/next_cycle_project_release.sql %VERSION% || goto :fail

echo [6/9] Freeze release in git

git restore .dbtools/project.config.json
git add -A dist/releases
git commit -m "Release %VERSION%"
git status
git diff --name-status

git commit -m "Freeze release %VERSION% baseline"
git checkout main

git merge --no-ff %STAGE_BRANCH% -m "Merge %STAGE_BRANCH% to main"

git tag v%VERSION%
git push -u origin main stage/%VERSION% --tags

echo [7/9] Optional incremental deploy to PROD (no reset)
echo If PROD already has previous version, this deploy applies only new changesets.

echo [8/9] Merge stage to main

git checkout main || goto :fail
git merge --no-ff %STAGE_BRANCH% -m "Merge %STAGE_BRANCH% to main" || goto :fail

echo [9/9] Final commit/tag push (manual review first)

echo NOTE: 
echo Deploy using SQLcl Project artifact:
echo   sql26 -name prod @src/scripts/during/next_cycle_project_deploy.sql %VERSION%

echo No LB diff/update-sql path is used in this incremental cycle script.
echo Review branch state and push when ready:
if defined REMOTE_NAME (
	echo   git push -u %REMOTE_NAME% main %STAGE_BRANCH% --tags
) else (
	echo   git push -u ^<your-remote^> main %STAGE_BRANCH% --tags
)
echo.
echo SUCCESS: next cycle flow completed.
goto :eof

:preflight
git rev-parse --is-inside-work-tree >nul 2>&1
if errorlevel 1 (
	echo ERROR: current folder is not a git repository.
	exit /b 1
)

set "HAS_CHANGES="
for /f %%i in ('git status --porcelain') do (
	set "HAS_CHANGES=1"
	goto :preflight_dirty_done
)
:preflight_dirty_done
if defined HAS_CHANGES (
	echo ERROR: working tree is not clean. Commit or stash changes before running cycle.
	git status --short
	exit /b 1
)

git show-ref --verify --quiet refs/heads/%FEATURE_BRANCH%
if not errorlevel 1 (
	echo ERROR: feature branch already exists: %FEATURE_BRANCH%
	exit /b 1
)

git show-ref --verify --quiet refs/heads/%STAGE_BRANCH%
if not errorlevel 1 (
	echo ERROR: stage branch already exists: %STAGE_BRANCH%
	exit /b 1
)

exit /b 0

:detect_remote
for /f %%r in ('git config --get branch.main.remote 2^>nul') do set "REMOTE_NAME=%%r"
if not defined REMOTE_NAME (
	for /f %%r in ('git remote') do (
		if not defined REMOTE_NAME set "REMOTE_NAME=%%r"
	)
)
exit /b 0

:pull_main
call :detect_remote
if not defined REMOTE_NAME (
	echo WARNING: no git remote configured. Skipping pull for main.
	exit /b 0
)

git ls-remote --exit-code --heads %REMOTE_NAME% main >nul 2>&1

if errorlevel 1 (
	echo WARNING: %REMOTE_NAME%/main does not exist yet. Skipping pull for initial remote bootstrap.
	exit /b 0
)

git rev-parse --abbrev-ref --symbolic-full-name @{u} >nul 2>&1
if errorlevel 1 (
	echo main has no upstream tracking. Using %REMOTE_NAME%/main and setting upstream...
	git pull %REMOTE_NAME% main || exit /b 1
	git branch  set-upstream-to=%REMOTE_NAME%/main main >nul 2>&1
	exit /b 0
)

git pull || exit /b 1
exit /b 0

:fail
echo.
echo ERROR: command failed with exit code %ERRORLEVEL%.
echo Stop point kept for investigation.
exit /b %ERRORLEVEL%

