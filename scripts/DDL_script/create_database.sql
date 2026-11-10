USE master;
GO

/*
============================================================================
DDL Script: Khởi tạo database và các schema cần thiết cho việc xây dựng 
database trên kiến trúc Medalion.

When to use: 
- Chạy một lần đầu tiên khi bắt đầu dự án.
- Khi đã vào môi trường production, tất cả các thao tác có tác động đến 
database và schema cần phải có sự thảo luận và xem xét kỹ lưỡng với các bên
liên quan.
============================================================================
*/

-- ==========================================================================
-- CREATE 'DataWarehouse' database if not exists
-- ==========================================================================
IF NOT EXISTS(SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN 
    CREATE DATABASE DataWarehouse;
END
GO

USE DataWarehouse;
GO

-- ==========================================================================
-- CREATE 'bronze' schema if not exists
-- ==========================================================================
IF NOT EXISTS(SELECT 1 FROM sys.schemas WHERE name = 'bronze')
BEGIN
    EXEC('CREATE SCHEMA bronze;');
END
GO

-- ==========================================================================
-- CREATE 'silver' schema if not exists
-- ==========================================================================
IF NOT EXISTS(SELECT 1 FROM sys.schemas WHERE name = 'silver')
BEGIN
    EXEC('CREATE SCHEMA silver;');
END
GO

-- ==========================================================================
-- CREATE 'gold' schema if not exists
-- ==========================================================================
IF NOT EXISTS(SELECT 1 FROM sys.schemas WHERE name = 'gold')
BEGIN
    EXEC('CREATE SCHEMA gold;');
END
GO


/*
    SELECT * FROM sys.databases WHERE name = 'DataWarehouse';
    SELECT * FROM sys.schemas WHERE name IN ('bronze', 'silver', 'gold');
*/