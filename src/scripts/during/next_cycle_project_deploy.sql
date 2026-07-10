set echo on
set feedback on
set define on

define artifact_version='&1'

PROJECT deploy -file ./artifact/PISAPI-&artifact_version..zip -verbose

exit
