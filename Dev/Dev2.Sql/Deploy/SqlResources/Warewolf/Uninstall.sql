/****************************************************************************
  This file is part of the Warewolf SQL Tools.
  Copyright (C) Warewolf.  All rights reserved.

  THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY
  KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
  IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
  PARTICULAR PURPOSE.
*****************************************************************************/

USE AdventureWorks2008R2
GO

IF OBJECT_ID ( '[Warewolf].[RunWorkflowForXml]', 'FS' ) IS NOT NULL 
	DROP FUNCTION [Warewolf].[RunWorkflowForXml];

IF OBJECT_ID ( '[Warewolf].[RunWorkflowForSql]', 'PC' ) IS NOT NULL  
	DROP PROCEDURE [Warewolf].[RunWorkflowForSql];

IF EXISTS( SELECT * FROM sys.assemblies WHERE name = 'Warewolf.Sql' )
	DROP ASSEMBLY [Warewolf.Sql];

IF EXISTS( SELECT * FROM sys.schemas WHERE name = 'Warewolf' )
	DROP SCHEMA [Warewolf];


USE master
GO

IF EXISTS( SELECT * FROM sys.syslogins WHERE name = 'WarewolfLogin' )
	DROP LOGIN WarewolfLogin;

IF EXISTS( SELECT * FROM sys.asymmetric_keys WHERE name = 'WarewolfKey' )
	DROP ASYMMETRIC KEY WarewolfKey;
