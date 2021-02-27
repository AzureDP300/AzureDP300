SELECT * FROM sys.sql_logins;
SELECT @@servername [NODE_NAME], 
    CASE 		
         WHEN SERVERPROPERTY('InstanceName') is null THEN @@servername+'.database.windows.net'
         else SERVERPROPERTY('InstanceName') 
    end [Instance_Name],
    'master' [Database_Name], 
    SP.[name] AS [Grantee], 
    type_desc as [Grantee_Type] , 
     'NA' [Grantee_Status], 
     'Instance Level Permission' as [PRIVILEGE_SOURCE],
    SPerm.permission_name COLLATE DATABASE_DEFAULT AS [Privilege], 
    Null as [Privilege_Path],
    Null as [OBJECT_NAME],
    Null as [OBJECT_TYPE], 
    Null as [OBJECT_OWNER],
    SPerm.state_desc as [Permission_State],
    Null AS [Password_Policy_Enforced]       
    FROM sys.database_principals SP  
    JOIN sys.database_permissions SPerm ON SP.principal_id = SPerm.grantee_principal_id  
    WHERE 
    --SPerm.type not in ('COSQ','G','CO')
    SP.type not in ('C')
    AND SP.name <> 'public' 
    UNION ALL 
    SELECT @@servername [NODE_NAME],
    CASE 		
         WHEN SERVERPROPERTY('InstanceName') is null THEN @@servername+'.database.windows.net'
         else SERVERPROPERTY('InstanceName') 
    end [Instance_Name],
    'master' [Database_Name], 
    SL.[name] AS [Grantee], 
    CASE 
         WHEN SL.type = 'S' THEN 'SQL USER' 
         WHEN SL.type = 'U' THEN 'AD USER'
         WHEN SL.type = 'G' THEN 'AD GROUP'
         WHEN SL.type = 'C' THEN 'CERTIFICATE'
         WHEN SL.type = 'K' THEN 'ASYMMETRIC KEY'
         ELSE 'Unknown'
     END [Grantee_Type] , 
     CASE WHEN SL.is_disabled = 0 THEN 'OPEN' ELSE 'LOCKED' END [Grantee_Status], 
     'Instance Level Permission' as [PRIVILEGE_SOURCE],
     Null as [Privilege],
     Null as [Privilege_Path],
    Null as [OBJECT_NAME],
    Null as [OBJECT_TYPE], 
    Null as [OBJECT_OWNER],
    'Grant' as [Permission_State],
    CASE SL.is_policy_checked
    WHEN 0 THEN 'No'
    WHEN 1 THEN 'Yes'
    ELSE NULL
    END AS [Password policy enforced] 
     
    FROM sys.sql_logins SL 
    WHERE 
    --SPerm.type not in ('COSQ','G','CO')
    SL.type not in ('C')
    AND SL.name <> 'public' 
    order by Grantee
