SELECT
  @@SERVERNAME InstanceName,
  DB_NAME() DatabaseName,
  SUM(CAST(DatabaseDataMaxSizeInBytes AS bigint) / 1024 / 1024 / 1024) MaximumDatabaseSizeInGB,
  CAST(SUM(DatabaseDataSpaceAllocatedInMB / 1024) AS decimal(10, 4)) DatabaseSpaceAllocatedInGB,
  CAST(SUM(Usedspace / 1024) AS decimal(10, 4)) DatabaseSpaceUsedInGB,
  CAST(SUM(DatabaseDataSpaceAllocatedUnusedInMB / 1024) AS decimal(10, 4)) DatabaseSpaceUnusedInGB
FROM (SELECT
  0 DatabaseDataSpaceAllocatedInMB,
  0 Usedspace,
  0 DatabaseDataSpaceAllocatedUnusedInMB,
  DATABASEPROPERTYEX('mydemodp300', 'MaxSizeInBytes') AS DatabaseDataMaxSizeInBytes
UNION
SELECT
  SUM(size / 128.0) AS DatabaseDataSpaceAllocatedInMB,
  SUM(CAST(FILEPROPERTY(name, 'SpaceUsed') AS int) / 128.0) AS UsedSpace,
  SUM(size / 128.0 - CAST(FILEPROPERTY(name, 'SpaceUsed') AS int) / 128.0) AS DatabaseDataSpaceAllocatedUnusedInMB,
  0
FROM sys.database_files
GROUP BY type_desc
HAVING type_desc = 'ROWS') T

