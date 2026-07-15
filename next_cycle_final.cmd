REM USAGE: next_cycle_final.cmd 1.3 cycle

set REF_URL=jdbc:oracle:thin:@pngodb.src.si:1521/pngordn
set REF_USER=PIS_STORITVE_POS
set REF_PASS=PIS_STORITVE_POS
set TGT_URL=jdbc:oracle:thin:@ora26ai.src.si:1521/orclpdb
set TGT_USER=PIS_STORITVE_POS
set TGT_PASS=PIS_STORITVE_POS

SET LD_LIBRARY_PATH=C:\Oracle\product\instantclient_23_26;C:\Oracle\product\instantclient_23_26;
SET LIQUIBASE_HOME=C:\Ant\liquibase\

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
set "LB_DIFF_FILE=lb_diff_%VERSION%.xml"
set "LB_DIFF_SQL=lb_diff_%VERSION%.sql"

echo ==========================================================
echo NEXT CYCLE RUNBOOK - VERSION %VERSION%
echo Feature branch: %FEATURE_BRANCH%
echo Stage branch:   %STAGE_BRANCH%
echo ==========================================================
echo.

echo [0/12] WIP before cycle run
git status
git add .
git commit -m "WIP before cycle run"

echo [1/12] Create feature branch from main
git checkout main || goto :fail

echo ==========================================================
echo PULL
echo ==========================================================

call :pull_main || goto :fail
git checkout -b %FEATURE_BRANCH% || goto :fail
echo.
echo Apply your schema/object changes in DEV now.
pause

echo ==========================================================
echo EXPORT
echo ==========================================================

echo [2/12] PROJECT export from DEV
sql26 -name dev @src/scripts/during/next_cycle_project_export.sql || goto :fail
echo.

echo [3/12] Commit feature changes and merge to main
git add .
git commit -m "Feature %TICKET%: export project changes"
git checkout main || goto :fail
git merge --no-ff %FEATURE_BRANCH% -m "Merge %FEATURE_BRANCH% to main" || goto :fail
git checkout -b %STAGE_BRANCH% || goto :fail
echo.
echo Update changelog includes now if needed, then continue.
pause

echo ==========================================================
echo STAGE
echo ==========================================================

echo [4/12] Commit stage changelog preparation

sql26 -name dev @src/scripts/during/next_cycle_project_stage.sql || goto :fail

git add .
git commit -m "Prepare release changelog %VERSION%"

echo ==========================================================
echo RELEASE, GEN ARTIFACT
echo ==========================================================

echo [5/12] PROJECT release and artifact generation
sql26 -name dev @src/scripts/during/next_cycle_project_release.sql %VERSION% || goto :fail

echo [6/12] Freeze release in git
git add .
git commit -m "Release %VERSION%"
git add dist/ artifact/
git commit -m "Freeze release %VERSION% baseline"
git tag %RELEASE_TAG%

echo [7/12] Optional LB diff generation (set env vars to enable)
echo Required vars: REF_URL REF_USER REF_PASS TGT_URL TGT_USER TGT_PASS
if "%REF_URL%"=="" goto :skip_lb_diff
if "%REF_USER%"=="" goto :skip_lb_diff
if "%REF_PASS%"=="" goto :skip_lb_diff
if "%TGT_URL%"=="" goto :skip_lb_diff
if "%TGT_USER%"=="" goto :skip_lb_diff
if "%TGT_PASS%"=="" goto :skip_lb_diff


echo ==========================================================
echo LB DIFF-CHNAGELOG
echo ==========================================================

rem lb diff-changelog -reference-url=%REF_URL% -reference-username=%REF_USER% -reference-password=%REF_PASS% -url=%TGT_URL% -username=%TGT_USER% -password=%TGT_PASS% -default-schema-name=PIS_STORITVE_POS -diff-types=columns,foreignkeys,indexes,primarykeys,tables,sequences,uniqueconstraints,views -include-schema=false -include-tablespace=false -output-default-schema=false -changelog-file=%LB_DIFF_FILE% || goto :fail

liquibase ^
 --url=%TGT_URL% ^
 --username=%TGT_USER% ^
 --password=%TGT_PASS% ^
 --reference-url=%REF_URL% ^
 --reference-username=%REF_USER% ^
 --reference-password=%REF_PASS% ^
 --default-schema-name=PIS_STORITVE_POS ^
 --diff-types=columns,foreignkeys,indexes,primarykeys,tables,sequences,uniqueconstraints,views ^
 --include-schema=false ^
 --include-tablespace=false ^
 --output-default-schema=false ^
 diff-changelog ^
 --changelog-file=%LB_DIFF_FILE% || goto :fail

echo ==========================================================
echo LB UPDATE
echo ==========================================================

rem lb update-sql -changelog-file=%LB_DIFF_FILE% -database-changelog-table-name=LB_CHANGES -default-schema-name=PIS_STORITVE_POS -liquibase-schema-name=PIS_STORITVE_POS -output-default-schema=false -output-file=%LB_DIFF_SQL% || goto :fail

liquibase ^
 --database-changelog-table-name=LB_CHANGES ^
 --default-schema-name=PIS_STORITVE_POS ^
 --liquibase-schema-name=PIS_STORITVE_POS ^
 --url=%TGT_URL% ^
 --username=%TGT_USER% ^
 --password=%TGT_PASS% ^
 --changelog-file=%LB_DIFF_FILE% ^
 --output-default-schema=false ^
 update-sql ^
 --output-file=%LB_DIFF_SQL% || goto :fail
 
goto :after_lb_diff

:skip_lb_diff
echo LB diff skipped because one or more env vars are missing.
echo.
:after_lb_diff

git add lb_diff_%VERSION%".xml lb_diff_%VERSION%".sql
git commit -m "LB diff and update-sql for %VERSION%"

echo [8/12] For deploy path A (SQLcl PROJECT deploy)  
echo [9/12] For deploy path B (LB Diff script)  
echo [10/12] Test deploy path C (LB update) 

echo [11/12] Merge stage to main

git checkout main || goto :fail
git merge --no-ff %STAGE_BRANCH% -m "Merge %STAGE_BRANCH% to main" || goto :fail

echo [12/12] Final commit/tag push (manual review first)

echo NOTE: 
echo Deploy using path A:
echo   sql26 -name prod @src/scripts/during/next_cycle_project_deploy.sql %VERSION%
echo Deploy using path B:
echo   sql26 -name prod @%LB_DIFF_SQL%
echo Deploy using path C:
echo   cd /d "%ROOT%src\lb\pis_storitve_pos"
echo   lb update -changelog-file changelog_gen_controller.xml -database-changelog-table-name LB_CHANGES
echo   cd /d "%ROOT%"
echo Review branch state and push when ready:
echo   git push -u origin main %STAGE_BRANCH% --tags
echo.
echo SUCCESS: next cycle flow completed.
goto :eof

echo ==========================================================
echo PULL_MAIN
echo ==========================================================

:pull_main
rem git rev-parse --abbrev-ref --symbolic-full-name @{u} >nul 2>&1
rem if errorlevel 1 (
rem   echo main has no upstream tracking. Using origin/main and setting upstream...
rem   git pull main || exit /b 1
rem   git branch --set-upstream-to=origin/main main >nul 2>&1
rem   exit /b 0
rem )
rem git pull || exit /b 1
exit /b 0

:fail
echo.
echo ERROR: command failed with exit code %ERRORLEVEL%.
echo Stop point kept for investigation.
exit /b %ERRORLEVEL%
