/*
======================================================
Create Database and Schemas
======================================================
Script Purpose: 
    This script creates a new database named 'DataWarehouse' after checking if it already exists.
    IF the database exists, it is dropped and recreated. Additonnaly, the scripts sets up three schemas
    within the database: 'bronze', 'silver', 'gold'.

WARNING:
    Running this script wiill drop the entire 'DataWarehouse' database if it exists.
    All data in the database will be permanently deleted. Proceed with caution and ensure you have proper
    backups before running this script.

*/

USE master;
GO

--Drop and recreate the 'DataWarehouse' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
	AlTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK INMEDIATE;
	DROP DATABASE DataWarehouse;
END;
GO

--Create Database 'Data Warehouse'
CREATE DATABASE DataWarehouse;

USE DataWarehouse;


--	Create Schemas
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO


