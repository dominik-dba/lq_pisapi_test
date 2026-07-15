set REF_URL=jdbc:oracle:thin:@pngodb.src.si:1521/pngordn
set REF_USER=PIS_STORITVE_POS
set REF_PASS=PIS_STORITVE_POS
set TGT_URL=jdbc:oracle:thin:@ora26ai.src.si:1521/orclpdb
set TGT_USER=PIS_STORITVE_POS
set TGT_PASS=PIS_STORITVE_POS

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

echo [1/12] Create feature branch from main
git checkout main || goto :fail
git pull || goto :fail
git checkout -b %FEATURE_BRANCH% || goto :fail
echo.
echo Apply your schema/object changes in DEV now.
pause

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

echo [4/12] Commit stage changelog preparation
git add .
git commit -m "Prepare release changelog %VERSION%"

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

lb diff-changelog -reference-url=%REF_URL% -reference-username=%REF_USER% -reference-password=%REF_PASS% -url=%TGT_URL% -username=%TGT_USER% -password=%TGT_PASS% -default-schema-name=PIS_STORITVE_POS -diff-types=columns,foreignkeys,indexes,primarykeys,tables,sequences,uniqueconstraints,views -include-schema=false -include-tablespace=false -output-default-schema=false -changelog-file=%LB_DIFF_FILE% || goto :fail

lb update-sql -changelog-file=%LB_DIFF_FILE% -database-changelog-table-name=LB_CHANGES -default-schema-name=PIS_STORITVE_POS -liquibase-schema-name=PIS_STORITVE_POS -output-default-schema=false -output-file=%LB_DIFF_SQL% || goto :fail
goto :after_lb_diff

:skip_lb_diff
echo LB diff skipped because one or more env vars are missing.
echo.
:after_lb_diff

echo [8/12] Test deploy path A: SQLcl PROJECT deploy
sql26 -name prod @src/scripts/during/prod_reset.sql || goto :fail
sql26 -name prod @src/scripts/during/next_cycle_project_deploy.sql %VERSION% || goto :fail
sql26 -name prod @src/scripts/during/prod_validate.sql || goto :fail

echo [9/12] Test deploy path B: diff SQL (if generated)
if exist "%LB_DIFF_SQL%" (
  sql26 -name prod @src/scripts/during/prod_reset.sql || goto :fail
  sql26 -name prod @%LB_DIFF_SQL% || goto :fail
  sql26 -name prod @src/scripts/during/prod_validate.sql || goto :fail
) else (
  echo Diff SQL file not found: %LB_DIFF_SQL% - skipping path B.
)

echo [10/12] Test deploy path C: LB update
sql26 -name prod @src/scripts/during/prod_reset.sql || goto :fail
cd /d "%ROOT%src\lb\pis_storitve_pos"
lb update -changelog-file changelog_gen_controller.xml -database-changelog-table-name LB_CHANGES || goto :fail
cd /d "%ROOT%"
sql26 -name prod @src/scripts/during/prod_validate.sql || goto :fail

echo [11/12] Merge stage to main
git checkout main || goto :fail
git merge --no-ff %STAGE_BRANCH% -m "Merge %STAGE_BRANCH% to main" || goto :fail

echo [12/12] Final commit/tag push (manual review first)
echo Review branch state and push when ready:
echo   git push -u origin main %STAGE_BRANCH% --tags

echo.
echo SUCCESS: next cycle flow completed.
goto :eof

:fail
echo.
echo ERROR: command failed with exit code %ERRORLEVEL%.
echo Stop point kept for investigation.
exit /b %ERRORLEVEL%
