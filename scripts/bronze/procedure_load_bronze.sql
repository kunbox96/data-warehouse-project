/*
=============================================================================================================
Script Purpose: Script dùng để load dữ liệu từ file csv vào bronze layer 

How it work: TRUNCATE -> BULK INSERT 

ERROR: Nếu xảy ra lỗi sẽ được ghi vào dbo.etl_error_logs table

Eg. Usage: 

EXEC bronze.load_bronze;

SELECT * FROM dbo.etl_error_logs;
=============================================================================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
    DECLARE @start_load DATETIME, @end_load DATETIME, @start_batch DATETIME, @end_batch DATETIME
    BEGIN TRY 
        BEGIN TRANSACTION

        -- ==================================================================================================
        -- crm_cust_info
        -- ==================================================================================================
        SET @start_batch = GETDATE();

        PRINT '================================='
        PRINT ' INSERT DATA FOR BRONZE LAYER '
        PRINT '=================================' + CHAR(13)

        SET @start_load = GETDATE();

        TRUNCATE TABLE bronze.crm_cust_info;
        PRINT 'Truncating table crm_cust_info completed'

        BULK INSERT bronze.crm_cust_info
        FROM 'C:\Users\Alvin Nguyen\Desktop\sql-datawarehouse-project\datasets\source_crm\cust_info.csv'
        WITH(
            FORMAT ='CSV',
            FIELDTERMINATOR=',',
            ROWTERMINATOR='\n',
            FIRSTROW=2,
            TABLOCK
        )
        SET @end_load = GETDATE();

        PRINT 'Inserting data for crm_cust_info completed' + CHAR(13)
        PRINT '>> Load duration: ' + CAST(DATEDIFF(second, @start_load, @end_load) AS NVARCHAR) + ' seconds'
        PRINT '--------------------------------------------'

        -- ==================================================================================================
        -- crm_prd_info
        -- ==================================================================================================
        SET @start_load = GETDATE();

        TRUNCATE TABLE bronze.crm_prd_info;
        PRINT 'Truncating table crm_prd_info completed'

        BULK INSERT bronze.crm_prd_info
        FROM 'C:\Users\Alvin Nguyen\Desktop\sql-datawarehouse-project\datasets\source_crm\prd_info.csv'
        WITH(
            FORMAT ='CSV',
            FIELDTERMINATOR=',',
            ROWTERMINATOR='\n',
            FIRSTROW=2,
            TABLOCK
        )
        SET @end_load = GETDATE();

        PRINT 'Inserting data for crm_prd_info completed' + CHAR(13)
        PRINT '>> Load duration: ' + CAST(DATEDIFF(second, @start_load, @end_load) AS NVARCHAR) + ' seconds'
        PRINT '--------------------------------------------'

        -- ==================================================================================================
        -- crm_sales_details
        -- ==================================================================================================
        SET @start_load = GETDATE();

        TRUNCATE TABLE bronze.crm_sales_details;
        PRINT 'Truncating table crm_sales_details completed' + CHAR(13)

        BULK INSERT bronze.crm_sales_details
        FROM 'C:\Users\Alvin Nguyen\Desktop\sql-datawarehouse-project\datasets\source_crm\sales_details.csv'
        WITH(
            FORMAT ='CSV',
            FIELDTERMINATOR=',',
            ROWTERMINATOR='\n',
            FIRSTROW=2,
            TABLOCK
        )
        SET @end_load = GETDATE();

        PRINT 'Inserting data for crm_sales_details completed'
        PRINT '>> Load duration: ' + CAST(DATEDIFF(second, @start_load, @end_load) AS NVARCHAR) + ' seconds'
        PRINT '--------------------------------------------'

        -- ==================================================================================================
        -- erp_cust_az12
        -- ==================================================================================================
        SET @start_load = GETDATE();

        TRUNCATE TABLE bronze.erp_cust_az12;

        BULK INSERT bronze.erp_cust_az12
        FROM 'C:\Users\Alvin Nguyen\Desktop\sql-datawarehouse-project\datasets\source_erp\CUST_AZ12.csv'
        WITH(
            FORMAT ='CSV',
            FIELDTERMINATOR=',',
            ROWTERMINATOR='\n',
            FIRSTROW=2,
            TABLOCK
        )
        SET @end_load = GETDATE();

        PRINT 'Inserting data for erp_loc_a101 completed'
        PRINT '>> Load duration: ' + CAST(DATEDIFF(second, @start_load, @end_load) AS NVARCHAR) + ' seconds'
        PRINT '--------------------------------------------'

        -- ==================================================================================================
        -- erp_loc_a101
        -- ==================================================================================================
        SET @start_load = GETDATE();

        TRUNCATE TABLE bronze.erp_loc_a101;

        BULK INSERT bronze.erp_loc_a101
        FROM 'C:\Users\Alvin Nguyen\Desktop\sql-datawarehouse-project\datasets\source_erp\LOC_A101.csv'
        WITH(
            FORMAT ='CSV',
            FIELDTERMINATOR=',',
            ROWTERMINATOR='\n',
            FIRSTROW=2,
            TABLOCK
        )
        SET @end_load = GETDATE();

        PRINT 'Inserting data for erp_loc_a101 completed'
        PRINT '>> Load duration: ' + CAST(DATEDIFF(second, @start_load, @end_load) AS NVARCHAR) + ' seconds'
        PRINT '--------------------------------------------'

        -- ==================================================================================================
        -- bronze.erp_px_cat_g1v2
        -- ==================================================================================================
        SET @start_load = GETDATE();

        TRUNCATE TABLE bronze.erp_px_cat_g1v2;
        PRINT 'Truncating table erp_px_cat_g1v2 completed'

        BULK INSERT bronze.erp_px_cat_g1v2
        FROM 'C:\Users\Alvin Nguyen\Desktop\sql-datawarehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
        WITH(
            FORMAT ='CSV',
            FIELDTERMINATOR=',',
            ROWTERMINATOR='\n',
            FIRSTROW=2,
            TABLOCK
        )
        SET @end_load = GETDATE();

        PRINT 'Inserting data for erp_px_cat_g1v2 completed'
        PRINT '>> Load duration: ' + CAST(DATEDIFF(second, @start_load, @end_load) AS NVARCHAR) + ' seconds'

        PRINT '--------------- DONE LOAD ---------------' + CHAR(13)
        COMMIT TRANSACTION;

        SET @end_batch = GETDATE();
        PRINT '================================================================================================='
        PRINT 'LOAD BRONZE LAYER COMPLETED'
        PRINT 'Load Bronze Layer Duration: ' + CAST(DATEDIFF(second, @start_batch, @end_batch) AS NVARCHAR)
        PRINT '================================================================================================='
    END TRY

    BEGIN CATCH
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
            PRINT N'Xảy ra lỗi trong quá trình Insert dữ liệu. Dữ liệu đã được rollback toàn bộ'
        END

        DECLARE @PROCNAME NVARCHAR(100) = OBJECT_NAME(@@PROCID);
        INSERT INTO dbo.etl_error_logs(
            procedure_name, 
            error_number, 
            error_severity, 
            error_state, 
            error_line, 
            error_message,
            error_time
        )
        VALUES(
            @PROCNAME,
            ERROR_NUMBER(),
            ERROR_SEVERITY(),
            ERROR_STATE(),
            ERROR_LINE(),
            ERROR_MESSAGE(),
            GETDATE()
        );

        -- Lấy và hiển thị thông tin chi tiết lỗi để dễ debug
		DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
		DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
		DECLARE @ErrorState INT = ERROR_STATE();
		DECLARE @ErrorLine INT = ERROR_LINE();

        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END
GO