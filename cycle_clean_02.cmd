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
SET VERSION=1.4
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
REM     "lastReleaseVersion" : "1.3"

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
git status
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
git commit -m "Release 1.4"
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
git tag v1.4
git push -u origin main stage/1.4 --tags

***** 
sql26 -name prod @src/scripts/during/next_cycle_project_deploy.sql %VERSION%



SQL> lb update -log -log-path "C:\Install\Db\PISAPILQ2050" -changelog-file releases/main.changelog.xml -search-path "." -def env/default.properties
--Starting Liquibase at 2026-07-16T12:07:36.169975300 using Java 21.0.5 (version 4.33.0 #0 built at 2025-12-09 17:47+0000)
Running Changeset: stage/1.4/pis_storitve_pos/tables/tmp_test2054.sql::1784195915370::PIS_STORITVE_POS
Migration failed, error reported:
The specified table or view did not exist

No Rollback for formatted sql change type


UPDATE SUMMARY
Run:                          0
Previously run:              60
Filtered out:                 0
-------------------------------
Total change sets:           62

ERROR: Exception Details
ERROR: Exception Primary Class:  DatabaseException
ERROR: Exception Primary Reason:  Error occurred and continueonerror set to false, stopping execution.
ERROR: Exception Primary Source:  4.33.0
Please review automatically generated error log:
sqlcl-lb-error1784196475979.log
For additional information run using -debug and/or -log parameters.


An error has occurred:
liquibase.exception.CommandExecutionException: liquibase.exception.LiquibaseException: 
liquibase.exception.MigrationFailedException: 
Migration failed for changeset stage/1.4/pis_storitve_pos/tables/tmp_test2054.sql::1784195915370::PIS_STORITVE_POS:
     Reason: liquibase.exception.DatabaseException: Error occurred and continueonerror set to false, 
	 stopping execution.
        at liquibase.command.CommandScope.lambda$execute$6(CommandScope.java:310)
        at liquibase.Scope.child(Scope.java:225)
        at liquibase.Scope.child(Scope.java:201)
        at liquibase.command.CommandScope.execute(CommandScope.java:251)
        at liquibase.Scope.child(Scope.java:225)
        at liquibase.Scope.child(Scope.java:201)
        at oracle.dbtools.raptor.liquibase.core.ActiveCommand.runCommand(ActiveCommand.java:439)
        at oracle.dbtools.raptor.liquibase.core.CommandGenerator.updateCommand(CommandGenerator.java:292)
        at oracle.dbtools.raptor.scriptrunner.commands.liquibase.LbCommand.handleEvent(LbCommand.java:355)
        at oracle.dbtools.raptor.newscriptrunner.CommandRegistry.lambda$fireListeners$4(CommandRegistry.java:485)
        at oracle.dbtools.raptor.newscriptrunner.ScriptRunnerContext.runWithStoredContext(ScriptRunnerContext.java:839)
        at oracle.dbtools.raptor.newscriptrunner.CommandRegistry.runWithStoredContext(CommandRegistry.java:705)
        at oracle.dbtools.raptor.newscriptrunner.CommandRegistry.fireListeners(CommandRegistry.java:463)
        at oracle.dbtools.raptor.newscriptrunner.ScriptRunner.lambda$run$0(ScriptRunner.java:241)
        at oracle.dbtools.raptor.newscriptrunner.ScriptRunnerContext.runWithStoredContext(ScriptRunnerContext.java:839)
        at oracle.dbtools.raptor.newscriptrunner.ScriptRunner.run(ScriptRunner.java:124)
        at oracle.dbtools.raptor.newscriptrunner.ScriptExecutor.run(ScriptExecutor.java:364)
        at oracle.dbtools.raptor.newscriptrunner.ScriptExecutor.run(ScriptExecutor.java:245)
        at oracle.dbtools.raptor.newscriptrunner.SQLPLUS.runExecuteFile(SQLPLUS.java:1779)
        at oracle.dbtools.raptor.newscriptrunner.SQLPLUS.run(SQLPLUS.java:186)
        at oracle.dbtools.raptor.newscriptrunner.ScriptRunner.runSQLPLUS(ScriptRunner.java:460)
        at oracle.dbtools.raptor.newscriptrunner.ScriptRunner.lambda$run$0(ScriptRunner.java:281)
        at oracle.dbtools.raptor.newscriptrunner.ScriptRunnerContext.runWithStoredContext(ScriptRunnerContext.java:839)
        at oracle.dbtools.raptor.newscriptrunner.ScriptRunner.run(ScriptRunner.java:124)
        at oracle.dbtools.raptor.newscriptrunner.ScriptExecutor.run(ScriptExecutor.java:364)
        at oracle.dbtools.raptor.newscriptrunner.ScriptExecutor.run(ScriptExecutor.java:245)
        at oracle.dbtools.runner.SqlClCommandsRunner.run(SqlClCommandsRunner.java:62)
        at oracle.dbtools.extension.project.commands.deploy.DeployCommand.deployArtifact(DeployCommand.java:192)
        at oracle.dbtools.extension.project.commands.deploy.DeployCommand.run(DeployCommand.java:272)
        at oracle.dbtools.extension.project.commands.handler.CommandHandler.DeployCommand(CommandHandler.java:149)
        at oracle.dbtools.extension.project.commands.handler.ProjectCommand.handleEvent(ProjectCommand.java:100)
        at oracle.dbtools.raptor.newscriptrunner.util.command.ParsedCommandListener.handleEvent(ParsedCommandListener.java:66)
        at oracle.dbtools.raptor.newscriptrunner.CommandRegistry.lambda$fireListeners$4(CommandRegistry.java:485)
        at oracle.dbtools.raptor.newscriptrunner.ScriptRunnerContext.runWithStoredContext(ScriptRunnerContext.java:839)
        at oracle.dbtools.raptor.newscriptrunner.CommandRegistry.runWithStoredContext(CommandRegistry.java:705)
        at oracle.dbtools.raptor.newscriptrunner.CommandRegistry.fireListeners(CommandRegistry.java:463)
        at oracle.dbtools.raptor.newscriptrunner.ScriptRunner.lambda$run$0(ScriptRunner.java:241)
        at oracle.dbtools.raptor.newscriptrunner.ScriptRunnerContext.runWithStoredContext(ScriptRunnerContext.java:839)
        at oracle.dbtools.raptor.newscriptrunner.ScriptRunner.run(ScriptRunner.java:124)
        at oracle.dbtools.raptor.newscriptrunner.ScriptExecutor.run(ScriptExecutor.java:364)
        at oracle.dbtools.raptor.newscriptrunner.ScriptExecutor.run(ScriptExecutor.java:245)
        at oracle.dbtools.raptor.scriptrunner.cmdline.SqlCli.runFile(SqlCli.java:1532)
        at oracle.dbtools.raptor.scriptrunner.cmdline.SqlCli.handleAtFiles(SqlCli.java:886)
        at oracle.dbtools.raptor.scriptrunner.cmdline.SqlCli.initSqlcl(SqlCli.java:1413)
        at oracle.dbtools.raptor.scriptrunner.cmdline.SqlCli.runSqlcl(SqlCli.java:1612)
        at oracle.dbtools.raptor.scriptrunner.cmdline.SqlCli.main(SqlCli.java:363)
Caused by: liquibase.exception.LiquibaseException: liquibase.exception.MigrationFailedException: Migration failed for changeset stage/1.4/pis_storitve_pos/tables/tmp_test2054.sql::1784195915370::PIS_STORITVE_POS:
     Reason: liquibase.exception.DatabaseException: Error occurred and continueonerror set to false, stopping execution.
        at liquibase.changelog.ChangeLogIterator.run(ChangeLogIterator.java:155)
        at liquibase.command.core.AbstractUpdateCommandStep.lambda$run$0(AbstractUpdateCommandStep.java:114)
        at liquibase.Scope.lambda$child$0(Scope.java:216)
        at liquibase.Scope.child(Scope.java:225)
        at liquibase.Scope.child(Scope.java:215)
        at liquibase.Scope.child(Scope.java:194)
        at liquibase.command.core.AbstractUpdateCommandStep.run(AbstractUpdateCommandStep.java:112)
        at liquibase.command.core.UpdateCommandStep.run(UpdateCommandStep.java:100)
        at liquibase.command.CommandScope.lambda$execute$6(CommandScope.java:263)
        ... 45 more
Caused by: liquibase.exception.MigrationFailedException: Migration failed for changeset stage/1.4/pis_storitve_pos/tables/tmp_test2054.sql::1784195915370::PIS_STORITVE_POS:
     Reason: liquibase.exception.DatabaseException: Error occurred and continueonerror set to false, stopping execution.
        at liquibase.changelog.ChangeSet.execute(ChangeSet.java:873)
        at liquibase.changelog.visitor.UpdateVisitor.executeAcceptedChange(UpdateVisitor.java:127)
        at liquibase.changelog.visitor.UpdateVisitor.visit(UpdateVisitor.java:71)
        at liquibase.changelog.ChangeLogIterator.lambda$run$0(ChangeLogIterator.java:133)
        at liquibase.Scope.lambda$child$0(Scope.java:216)
        at liquibase.Scope.child(Scope.java:225)
        at liquibase.Scope.child(Scope.java:215)
        at liquibase.Scope.child(Scope.java:194)
        at liquibase.changelog.ChangeLogIterator.lambda$run$1(ChangeLogIterator.java:122)
        at liquibase.Scope.lambda$child$0(Scope.java:216)
        at liquibase.Scope.child(Scope.java:225)
        at liquibase.Scope.child(Scope.java:215)
        at liquibase.Scope.child(Scope.java:194)
        at liquibase.Scope.child(Scope.java:282)
        at liquibase.Scope.child(Scope.java:286)
        at liquibase.changelog.ChangeLogIterator.run(ChangeLogIterator.java:91)
        ... 53 more
Caused by: liquibase.exception.DatabaseException: Error occurred and continueonerror set to false, stopping execution.
        at oracle.dbtools.raptor.liquibase.executor.jvm.SqlClExecutor.execute(SqlClExecutor.java:206)
        at liquibase.executor.AbstractExecutor.execute(AbstractExecutor.java:148)
        at oracle.dbtools.raptor.liquibase.executor.jvm.SqlClExecutor.execute(SqlClExecutor.java:318)
        at liquibase.database.AbstractJdbcDatabase.executeStatements(AbstractJdbcDatabase.java:1198)
        at liquibase.changelog.ChangeSet.execute(ChangeSet.java:816)
        ... 68 more

Error occurred and continueonerror set to false, stopping execution.
SQL>
SQL> -- @utils/recompile.sql

Log file(s) location: C:\Install\Db\PISAPILQ2050
Removing the decompressed artifact: C:\TEMP\07edcf0a-49c1-4635-a863-9934ccfaab962604200407925447526...
SQL>
SQL> exit
Disconnected from Oracle AI Database 26ai Enterprise Edition Release 23.26.1.0.0 - Production
Version 23.26.1.0.0



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




sql26 -name prod @src/scripts/during/prod_validate.sql

REM   sql26 -name prod
REM   desc pis_storitve_pos.tmp_test2054 -- ne obstaja tabela, pričakuje se s poljem AGE
REM     expecting AGE, NEWAGE
REM   desc pis_storitve_pos.tmp_test2055 -- ne obstaja
REM   desc pis_storitve_pos.tmp_test2056 



