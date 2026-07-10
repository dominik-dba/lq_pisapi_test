set echo on
set feedback on
set define on

define release_version='&1'

PROJECT release -version &release_version
PROJECT gen-artifact

exit
