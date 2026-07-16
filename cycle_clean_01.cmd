REM Correct order for your process:
REM 
REM 1. Create feature from main.
REM 2. Do DB changes + PROJECT export on feature.
REM 3. Commit feature.
REM 4. Create stage branch from feature (or move feature commits onto stage).
REM 5. Run PROJECT stage on stage branch.
REM 6. Review/commit stage outputs.
REM 7. Run PROJECT release -version 1.3.
REM 8. Merge stage into main.
REM 9. Tag and push

SET LD_LIBRARY_PATH=C:\Oracle\product\instantclient_23_26;C:\Oracle\product\instantclient_23_26
SET LIQUIBASE_HOME=C:\Ant\liquibase\
SET VERSION=1.5
SET TICKET=cycle
SET ROOT=C:\Install\Db\PISAPILQ2050
set "FEATURE_BRANCH=feature/PISAPI-%VERSION%-%TICKET%"
set "STAGE_BRANCH=stage/%VERSION%"
set "RELEASE_TAG=v%VERSION%"
set "ARTIFACT=artifact\PISAPI-%VERSION%.zip"
set "REMOTE_NAME="
set "LB_DIFF_FILE=lb_diff_%VERSION%.xml"
set "LB_DIFF_SQL=lb_diff_%VERSION%.sql"
set REMOTE_NAME=origin

REM Check .dbtools\project.config.json
REM     "lastReleaseVersion" : "1.4"

git checkout main
git add .
git commit -m "NC"
git push
cd /d "%ROOT%"

REM 1. Create feature from main.

REM git rev-parse --is-inside-work-tree
REM REM git push
REM REM git checkout main
REM git ls-remote --exit-code --heads %REMOTE_NAME% main
REM git rev-parse --abbrev-ref --symbolic-full-name @{u}
REM REM git pull 
git checkout -b %FEATURE_BRANCH% 

REM 2. Do DB changes + PROJECT export on feature.

REM Do database changes on dev
REM   sql26 -name dev
REM   alter table pis_storitve_pos.tmp_test2054 add AGE NUMBER;
REM   create table pis_storitve_pos.tmp_test2055 as select * from pis_storitve_pos.tmp_test2054;
REM   alter table pis_storitve_pos.tmp_test2054 add NEWAGE NUMBER;
REM   create table pis_storitve_pos.tmp_test2056 as select * from pis_storitve_pos.tmp_test2054;



REM sql26 -name dev
REM PROJECT export -schemas PIS_STORITVE_POS,PIS_STORITVE_APP -verbose
REM exit

sql26 -name dev @src/scripts/during/next_cycle_project_export.sql

REM 3. Commit feature.

REM git add -A
git add .
git commit -m "Feature %TICKET%: export project changes"

REM 4. Create stage branch from feature (or move feature commits onto stage).

REM NEW

REM Option A: create stage directly from feature (recommended)
REM 
REM Make sure feature has your latest commit:

REM WRONG git checkout main 

REM WRONG git merge --no-ff %FEATURE_BRANCH% -m "Merge %FEATURE_BRANCH% to main"

REM git checkout feature/PISAPI-%VERSION%-cycle
REM git status
REM Create stage from that exact feature tip:
git checkout -b %STAGE_BRANCH% 
REM Verify relation:
git log --oneline --decorate --graph -n 10

	REM B: stage exists already, move it to feature tip
	REM 
	REM Update/create stage pointer to feature:
	REM git branch -f stage/1.3 feature/PISAPI-1.3-cycle
	REM Switch to stage:
	REM git checkout stage/1.3

REM 5. Run PROJECT stage on stage branch.

REM sql26 -name dev
REM PROJECT stage -verbose
sql26 -name dev @src/scripts/during/next_cycle_project_stage.sql


	REM Stage is Comparing:
	REM Old Branch      refs/heads/main
	REM New Branch      refs/heads/stage/1.4
	REM 
	REM Created file:  dist\releases\next\changes\stage\1.4\pis_storitve_pos\tables\tmp_test2056.sql
	REM Created change:dist\releases\next\changes\stage\1.4\stage.changelog.xml
	REM Created change:dist\releases\next\release.changelog.xml
	REM Updated change:dist\releases\main.changelog.xml
	REM Updated change:dist\releases\next\release.changelog.xml
	REM Updated change:dist\releases\next\changes\stage\1.4\stage.changelog.xml
	REM Sorted and Saved file:  dist\releases\next\changes\stage\1.4\stage.changelog.xml
	REM 
	REM Completed executing stage command on branch: stage/1.4


REM 6. Review/commit stage outputs.

REM git add -A
git add .
git commit -m "Prepare release changelog %VERSION%"

REM if not exist dist\releases\next mkdir dist\releases\next
REM C:\Install\Db\PISAPILQ2050\dist\releases\next\release.changelog.xml
REM 
REM <?xml version="1.0" encoding="UTF-8"?>
REM <databaseChangeLog xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
REM 						   xmlns="http://www.liquibase.org/xml/ns/dbchangelog"
REM 						   xsi:schemaLocation="http://www.liquibase.org/xml/ns/dbchangelog
REM 						   http://www.liquibase.org/xml/ns/dbchangelog/dbchangelog-4.3.xsd">
REM </databaseChangeLog>

REM 7. Run PROJECT release -version 1.4

REM sql26 -name dev
REM PROJECT release -version 1.4
REM PROJECT gen-artifact

sql26 -name dev @src/scripts/during/next_cycle_project_release.sql %VERSION%


REM 8. Merge stage into main.


git restore .dbtools/project.config.json
git add -A dist/releases
git commit -m "Release %VERSION%"
git status
git diff --name-status

git checkout main

git merge --no-ff %STAGE_BRANCH% -m "Merge %STAGE_BRANCH% to main"

	REM Merge made by the 'ort' strategy.
	REM  .../stage/1.4/pis_storitve_pos/tables/tmp_test2054.sql       |  9 +++++++++
	REM  .../stage/1.4/pis_storitve_pos/tables/tmp_test2056.sql       | 12 ++++++++++++
	REM  dist/releases/1.4/changes/stage/1.4/stage.changelog.xml      |  8 ++++++++
	REM  dist/releases/1.4/release.changelog.xml                      |  8 ++++++++
	REM  dist/releases/main.changelog.xml                             |  3 ++-
	REM  src/database/pis_storitve_pos/tables/tmp_test2054.sql        |  5 +++--
	REM  src/database/pis_storitve_pos/tables/tmp_test2056.sql        | 10 ++++++++++
	REM  7 files changed, 52 insertions(+), 3 deletions(-)
	REM  create mode 100644 dist/releases/1.4/changes/stage/1.4/pis_storitve_pos/tables/tmp_test2054.sql
	REM  create mode 100644 dist/releases/1.4/changes/stage/1.4/pis_storitve_pos/tables/tmp_test2056.sql
	REM  create mode 100644 dist/releases/1.4/changes/stage/1.4/stage.changelog.xml
	REM  create mode 100644 dist/releases/1.4/release.changelog.xml
	REM  create mode 100644 src/database/pis_storitve_pos/tables/tmp_test2056.sql



REM 9. Tag and push
git tag v%VERSION%
git push -u origin main stage/%VERSION% --tags

***** 
sql26 -name prod @src/scripts/during/next_cycle_project_deploy.sql %VERSION%

REM On prod. missing part
REM create table pis_storitve_pos.tmp_test2054 as select * from pis_storitve_pos.tmp_test2053;
REM alter table pis_storitve_pos.tmp_test2054 add AGE NUMBER;
REM create table pis_storitve_pos.tmp_test2055 as select * from pis_storitve_pos.tmp_test2054;


[C:\Install\Db\PISAPILQ2050]sql26 -name prod @src/scripts/during/next_cycle_project_deploy.sql %VERSION%
SQLcl: Release 26.1 Production on Thu Jul 16 12:15:38 2026

Copyright (c) 1982, 2026, Oracle.  All rights reserved.

Connected to:
Oracle AI Database 26ai Enterprise Edition Release 23.26.1.0.0 - Production
Version 23.26.1.0.0

SQL> set feedback on
SQL> set define on
SQL>
SQL> define artifact_version='&1'
SQL>
SQL> PROJECT deploy -file ./artifact/PISAPI-&artifact_version..zip -verbose
Check database connection...
Extract the file name: PISAPI-1.4
Extract the file name: PISAPI-1.4
Artifact decompression in progress...
Artifact decompressed: C:\TEMP\5d211769-3cee-4201-a1b7-d18f91b7783a1225770974906805820
Starting the migration...
SQL> cd C:\TEMP\5d211769-3cee-4201-a1b7-d18f91b7783a1225770974906805820
SQL> @install.sql
SQL> -- SQLcl uses the SQLCL engine for formatted sql changelog not the JDBC engine
SQL> -- By default, a project will not use substitution variables and allows blank
SQL> -- lines in sql statements.
SQL>
SQL> set define off
SQL> set sqlblanklines on
SQL>
SQL> -- Prechecks modifiable helper
SQL> -- Check running with SQLcl
SQL> -- Check minimum DB version
SQL> -- Check character set
SQL> --@utils/prechecks.sql
SQL>
SQL> -- SLOT
SQL> -- Custom pre Liquibase code here (perhaps creation of a schema)
SQL> -- This is MINIMAL pre setup, everything that can go through Liquibase - SHOULD
SQL>
SQL> -- Kick off Liquibase
SQL> prompt "Installing/updating schemas"
Installing/updating schemas
SQL> -- lb update -log -log-path "C:\Install\Db\PISAPILQ2050" -changelog-file releases/main.changelog.xml -search-path "." -def env/default.properties
SQL> lb update -log -log-path "C:\Install\Db\PISAPILQ2050" -changelog-file releases/main.changelog.xml -search-path "." -def env/default.properties
--Starting Liquibase at 2026-07-16T12:15:41.769208800 using Java 21.0.5 (version 4.33.0 #0 built at 2025-12-09 17:47+0000)
Running Changeset: stage/1.4/pis_storitve_pos/tables/tmp_test2054.sql::1784195915370::PIS_STORITVE_POS
SQL> -- sqlcl_snapshot src/database/pis_storitve_pos/tables/tmp_test2054.sql:4e0b17b3b69b1770bba8e81ef23cff7ad796c469:a7e1c4c511131f429fd321b42f73d5ee43d0d4ff:alter
SQL>
SQL> alter table pis_storitve_pos.tmp_test2054 add (
  2      newage number
  3  )

Table PIS_STORITVE_POS.TMP_TEST2054 altered.
Running Changeset: stage/1.4/pis_storitve_pos/tables/tmp_test2056.sql::1784195914529::PIS_STORITVE_POS
SQL> -- sqlcl_snapshot src/database/pis_storitve_pos/tables/tmp_test2056.sql:null:c391e770b7e3dd0cb5863ca0c43af860c436adf2:create
SQL>
SQL> create table pis_storitve_pos.tmp_test2056 (
  2      id      number,
  3      ime     varchar2(200 char),
  4      priimek varchar2(200 char),
  5      age     number,
  6      newage  number
  7  );

Table PIS_STORITVE_POS.TMP_TEST2056 created.

UPDATE SUMMARY
Run:                          2
Previously run:              60
Filtered out:                 0
-------------------------------
Total change sets:           62

Liquibase: Update has been successful. Rows affected: 0

Produced logfile: sqlcl-lb-1784196941569.log

Operation completed successfully.

SQL>
SQL> -- @utils/recompile.sql

Log file(s) location: C:\Install\Db\PISAPILQ2050
Removing the decompressed artifact: C:\TEMP\5d211769-3cee-4201-a1b7-d18f91b7783a1225770974906805820...
SQL>
SQL> exit
Disconnected from Oracle AI Database 26ai Enterprise Edition Release 23.26.1.0.0 - Production
Version 23.26.1.0.0




REM REM sql26 -name prod @src/scripts/during/prod_validate.sql

REM   sql26 -name prod
REM   desc pis_storitve_pos.tmp_test2054 -- ne obstaja tabela, pričakuje se s poljem AGE
REM     expecting AGE, NEWAGE
REM   desc pis_storitve_pos.tmp_test2055 -- ne obstaja
REM   desc pis_storitve_pos.tmp_test2056 



REM   alter table pis_storitve_pos.tmp_test2054 add NASLOV VARCHAR2(200);
REM   alter table pis_storitve_pos.tmp_test2054 add NASELJE VARCHAR2(200);
REM   create table pis_storitve_pos.tmp_test2057 as select * from pis_storitve_pos.tmp_test2056;

