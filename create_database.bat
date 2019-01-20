sqlcmd -S %1 -i DDL\01_tables.sql
sqlcmd -S %1 -i DDL\02_functions.sql
sqlcmd -S %1 -i DDL\03_constraints.sql
sqlcmd -S %1 -i DDL\04_triggers.sql
sqlcmd -S %1 -i DDL\05_indexes.sql
sqlcmd -S %1 -i DDL\06_procedures.sql

sqlcmd -S %1 -i DQL\01_views.sql

