/*
=============================================
Usage: Đối chiếu số lượng dòng trong file csv
với số lượng inserted.

Bronze layer không có transform action. 
Only Insert Raw Data

Nếu có bất cứ chênh lệch nào kiểm tra lại 
procedure_load_bronze.sql file hoặc điều chỉnh
lại bronze.load_bronze procedure 
=============================================
*/

-- ERP SYSTEM COUNT
SELECT COUNT(*) FROM bronze.crm_cust_info;
SELECT COUNT(*) FROM bronze.crm_prd_info;
SELECT COUNT(*) FROM bronze.crm_sales_details;


-- ERP SYSTEM COUNT

SELECT COUNT(*) FROM bronze.erp_cust_az12;
SELECT COUNT(*) FROM bronze.erp_loc_a101;
SELECT COUNT(*) FROM bronze.erp_px_cat_g1v2;