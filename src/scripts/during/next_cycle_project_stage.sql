



set echo on
set feedback on
set define on

define release_version='&1'

PROJECT stage -version &release_version -verbose

exit