USE DataWarehouse;
GO

/*
============================================================================
DDL Script: Tạo table cho tầng bronze và silver layer
When to use: 
- Chạy một lần đầu tiên khi bắt đầu dự án.
- Nếu cần chỉnh sửa data type yêu cầu phải có bàn bạc và cân nhắc từ các
bên liên quan (Data Engineer Team)
============================================================================
*/


-- ==========================================================================
-- Purpose: CREATE TABLES cho bronze layer
-- Specification: 
--   Dữ liệu ở tầng bronze sẽ là dữ liệu gốc không chỉnh sửa gì được 
--   Batch processing from CSV file xuất ra từ CRM & ERP system.
--   Naming convention follow theo naming_conventions.md
--   eg: <sourcesystem>_<entity> = crm_cust_info
-- ==========================================================================

-- ==========================================================================
--               CREATE LOGS TABLE
-- ==========================================================================
IF OBJECT_ID('dbo.etl_error_logs','U') IS NULL

CREATE TABLE dbo.etl_error_logs (
    log_id              INT IDENTITY(1,1) NOT NULL,
    procedure_name      NVARCHAR(50) NOT NULL, 
    error_number        INT NULL, 
    error_severity      INT NULL, 
    error_state         INT NULL, 
    error_line          INT NULL, 
    error_message       NVARCHAR(4000) NULL,
    error_time          DATETIME NULL

    CONSTRAINT PK_etl_error_logs PRIMARY KEY CLUSTERED (log_id)
)

-- ==========================================================================
--               bronze.crm_cust_info
-- ==========================================================================
IF OBJECT_ID('bronze.crm_cust_info', 'U') IS NOT NULL
BEGIN
    DROP TABLE bronze.crm_cust_info;
    PRINT N'Deleted bronze.crm_cust_info'
END
GO

CREATE TABLE bronze.crm_cust_info (
    cst_id              INT,
    cst_key             NVARCHAR(50),
    cst_firstname       NVARCHAR(50),
    cst_lastname        NVARCHAR(50),
    cst_marital_status  NVARCHAR(50),
    cst_gndr            NVARCHAR(50),
    cst_create_date     DATE
);
PRINT N'Success created bronze.crm_cust_info' + CHAR(13);
GO


-- ==========================================================================
--               bronze.crm_prd_info
-- ==========================================================================
IF OBJECT_ID('bronze.crm_prd_info', 'U') IS NOT NULL
BEGIN
    DROP TABLE bronze.crm_prd_info;
    PRINT N'Deleted bronze.crm_prd_info'
END
GO

CREATE TABLE bronze.crm_prd_info (
    prd_id              INT,
    prd_key             NVARCHAR(50),
    prd_nm              NVARCHAR(50),
    prd_cost            INT,
    prd_line            NVARCHAR(50),
    prd_start_dt        DATE,
    prd_end_dt          DATE
);
PRINT N'Success created bronze.crm_prd_info' + CHAR(13);
GO


-- ==========================================================================
--               bronze.crm_sales_details
-- ==========================================================================
IF OBJECT_ID('bronze.crm_sales_details', 'U') IS NOT NULL
BEGIN
    DROP TABLE bronze.crm_sales_details;
    PRINT N'Deleted bronze.crm_sales_details'
END
GO

CREATE TABLE bronze.crm_sales_details (
    sls_ord_num         NVARCHAR(50),
    sls_prd_key         NVARCHAR(50),
    sls_cust_id         NVARCHAR(50),
    sls_order_dt        NVARCHAR(50),
    sls_ship_dt         NVARCHAR(50),
    sls_due_dt          NVARCHAR(50),
    sls_sales           INT,
    sls_quantity        INT,
    sls_price           INT
);
PRINT N'Success created bronze.crm_sales_details' + CHAR(13);
GO


-- ================================
--            ERP TABLES
-- ================================


-- ==========================================================================
--               bronze.erp_cust_az12
-- ==========================================================================
IF OBJECT_ID('bronze.erp_cust_az12', 'U') IS NOT NULL
BEGIN
    DROP TABLE bronze.erp_cust_az12;
    PRINT N'Deleted bronze.erp_cust_az12'
END
GO

CREATE TABLE bronze.erp_cust_az12 (
    cid         NVARCHAR(50),
    bdate       DATE,
    gen         NVARCHAR(50)
);
PRINT N'Success created bronze.erp_cust_az12' + CHAR(13);
GO


-- ==========================================================================
--               bronze.erp_loc_a101
-- ==========================================================================
IF OBJECT_ID('bronze.erp_loc_a101', 'U') IS NOT NULL
BEGIN
    DROP TABLE bronze.erp_loc_a101;
    PRINT N'Deleted bronze.erp_loc_a101'
END
GO

CREATE TABLE bronze.erp_loc_a101 (
    cid         NVARCHAR(50),
    cntry       NVARCHAR(50)
);
PRINT N'Success created bronze.erp_loc_a101' + CHAR(13);
GO


-- ==========================================================================
--               bronze.erp_px_cat_g1v2
-- ==========================================================================
IF OBJECT_ID('bronze.erp_px_cat_g1v2', 'U') IS NOT NULL
BEGIN
    DROP TABLE bronze.erp_px_cat_g1v2;
    PRINT N'Deleted bronze.erp_px_cat_g1v2'
END
GO

CREATE TABLE bronze.erp_px_cat_g1v2 (
    id          NVARCHAR(50),
    cat         NVARCHAR(50),
    subcat      NVARCHAR(50),
    maintenance NVARCHAR(50)
);
PRINT N'Success created bronze.erp_px_cat_g1v2' + CHAR(13);
GO

-----------------------------------------------------------------------------

-- ==========================================================================
-- Purpose: CREATE TABLES cho silver layer
-- Specification: 
--   Dữ liệu ở tầng silver sẽ là dữ liệu đã được cleanse 
--   INSERT AFTER CLEANSE from BRONZE LAYER
-- ==========================================================================

-- ==========================================================================
--               silver.crm_cust_info
-- ==========================================================================
IF OBJECT_ID('silver.crm_cust_info', 'U') IS NOT NULL
BEGIN
    DROP TABLE silver.crm_cust_info;
    PRINT N'Deleted silver.crm_cust_info'
END
GO

CREATE TABLE silver.crm_cust_info (
    cst_id              INT,
    cst_key             NVARCHAR(50),
    cst_firstname       NVARCHAR(50),
    cst_lastname        NVARCHAR(50),
    cst_marital_status  NVARCHAR(50),
    cst_gndr            NVARCHAR(50),
    cst_create_date     DATE,
    dwh_create_date     DATETIME2 DEFAULT GETDATE(), -- Enrich data: default là thời gian insert dữ liệu
    dwh_update_date     DATETIME2 DEFAULT GETDATE()  -- Enrich data: default là thời gian insert dữ liệu
);
PRINT N'Success created silver.crm_cust_info' + CHAR(13);
GO


-- ==========================================================================
--               silver.crm_prd_info
-- ==========================================================================
IF OBJECT_ID('silver.crm_prd_info', 'U') IS NOT NULL
BEGIN
    DROP TABLE silver.crm_prd_info;
    PRINT N'Deleted silver.crm_prd_info'
END
GO

CREATE TABLE silver.crm_prd_info (
    prd_id              INT,
    prd_key             NVARCHAR(50),
    prd_nm              NVARCHAR(50),
    prd_cost            INT,
    prd_line            NVARCHAR(50),
    prd_start_dt        DATE,
    prd_end_dt          DATE,
    dwh_create_date     DATETIME2 DEFAULT GETDATE(), -- Enrich data: default là thời gian insert dữ liệu
    dwh_update_date     DATETIME2 DEFAULT GETDATE()  -- Enrich data: default là thời gian insert dữ liệu
);
PRINT N'Success created silver.crm_prd_info' + CHAR(13);
GO


-- ==========================================================================
--               silver.crm_sales_details
-- ==========================================================================
IF OBJECT_ID('silver.crm_sales_details', 'U') IS NOT NULL
BEGIN
    DROP TABLE silver.crm_sales_details;
    PRINT N'Deleted silver.crm_sales_details'
END
GO

CREATE TABLE silver.crm_sales_details (
    sls_ord_num         NVARCHAR(50),
    sls_prd_key         NVARCHAR(50),
    sls_cust_id         NVARCHAR(50),
    sls_order_dt        NVARCHAR(50),
    sls_ship_dt         NVARCHAR(50),
    sls_due_dt          NVARCHAR(50),
    sls_sales           INT,
    sls_quantity        INT,
    sls_price           INT,
    dwh_create_date     DATETIME2 DEFAULT GETDATE(), -- Enrich data: default là thời gian insert dữ liệu
    dwh_update_date     DATETIME2 DEFAULT GETDATE()  -- Enrich data: default là thời gian insert dữ liệu
);
PRINT N'Success created silver.crm_sales_details' + CHAR(13);
GO


-- ================================
--            ERP TABLES
-- ================================


-- ==========================================================================
--               silver.erp_cust_az12
-- ==========================================================================
IF OBJECT_ID('silver.erp_cust_az12', 'U') IS NOT NULL
BEGIN
    DROP TABLE silver.erp_cust_az12;
    PRINT N'Deleted silver.erp_cust_az12'
END
GO

CREATE TABLE silver.erp_cust_az12 (
    cid                 NVARCHAR(50),
    bdate               DATE,
    gen                 NVARCHAR(50),
    dwh_create_date     DATETIME2 DEFAULT GETDATE(), -- Enrich data: default là thời gian insert dữ liệu
    dwh_update_date     DATETIME2 DEFAULT GETDATE()  -- Enrich data: default là thời gian insert dữ liệu
);
PRINT N'Success created silver.erp_cust_az12' + CHAR(13);
GO


-- ==========================================================================
--               silver.erp_loc_a101
-- ==========================================================================
IF OBJECT_ID('silver.erp_loc_a101', 'U') IS NOT NULL
BEGIN
    DROP TABLE silver.erp_loc_a101;
    PRINT N'Deleted silver.erp_loc_a101'
END
GO

CREATE TABLE silver.erp_loc_a101 (
    cid                 NVARCHAR(50),
    cntry               NVARCHAR(50),
    dwh_create_date     DATETIME2 DEFAULT GETDATE(), -- Enrich data: default là thời gian insert dữ liệu
    dwh_update_date     DATETIME2 DEFAULT GETDATE()  -- Enrich data: default là thời gian insert dữ liệu
);
PRINT N'Success created silver.erp_loc_a101' + CHAR(13);
GO


-- ==========================================================================
--               silver.erp_px_cat_g1v2
-- ==========================================================================
IF OBJECT_ID('silver.erp_px_cat_g1v2', 'U') IS NOT NULL
BEGIN
    DROP TABLE silver.erp_px_cat_g1v2;
    PRINT N'Deleted silver.erp_px_cat_g1v2'
END
GO

CREATE TABLE silver.erp_px_cat_g1v2 (
    id                  NVARCHAR(50),
    cat                 NVARCHAR(50),
    subcat              NVARCHAR(50),
    maintenance         NVARCHAR(50),
    dwh_create_date     DATETIME2 DEFAULT GETDATE(), -- Enrich data: default là thời gian insert dữ liệu
    dwh_update_date     DATETIME2 DEFAULT GETDATE()  -- Enrich data: default là thời gian insert dữ liệu
);
PRINT N'Success created silver.erp_px_cat_g1v2' + CHAR(13);
GO