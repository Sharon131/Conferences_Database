sqlcmd -S %1 -i DDL\01_tables.sql
sqlcmd -S %1 -i DDL\02_constraints.sql
sqlcmd -S %1 -i DDL\03_triggers.sql
sqlcmd -S %1 -i DDL\04_indexes.sql
sqlcmd -S %1 -i DDL\05_procedures.sql

sqlcmd -S %1 -i DQL\01_views.sql

