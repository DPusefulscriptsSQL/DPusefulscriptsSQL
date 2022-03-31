/*
	SQL SERVER 2019 - Compatibility level 150
  AND No Latest cumulative updates are deployed

*/
Option 1:
        Run this command
        ALTER DATABASE SCOPED CONFIGURATION SET TSQL_SCALAR_UDF_INLINING = OFF;
Option 2:
        Lower your compatibility level
Option 3:
        Install latest cumulative update for your SQL server (Recommended).
