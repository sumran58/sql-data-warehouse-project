BULK INSERT Bronze.crm_cust_info
FROM 'C:\Users\windows\Downloads\f78e076e5b83435d84c6b6af75d8a679\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
WITH(
FIRSTROW=2,
FIELDTERMINATOR=',',
TABLOCK
);

SELECT * FROM Bronze.crm_cust_info;

BULK INSERT Bronze.crm_prd_info
FROM 'C:\Users\windows\Downloads\f78e076e5b83435d84c6b6af75d8a679\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
WITH(
FIRSTROW=2,
FIELDTERMINATOR=',',
TABLOCK
);

BULK INSERT Bronze.crm_sales_details
FROM 'C:\Users\windows\Downloads\f78e076e5b83435d84c6b6af75d8a679\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
WITH(
FIRSTROW=2,
FIELDTERMINATOR=',',
TABLOCK
);

BULK INSERT Bronze.erp_cust_az12
FROM 'C:\Users\windows\Downloads\f78e076e5b83435d84c6b6af75d8a679\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
WITH(
FIRSTROW=2,
FIELDTERMINATOR=',',
TABLOCK
);

BULK INSERT Bronze.erp_loc_a101
FROM 'C:\Users\windows\Downloads\f78e076e5b83435d84c6b6af75d8a679\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
WITH(
FIRSTROW=2,
FIELDTERMINATOR=',',
TABLOCK
);

BULK INSERT Bronze.erp_px_cat_g1v2
FROM 'C:\Users\windows\Downloads\f78e076e5b83435d84c6b6af75d8a679\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
WITH(
FIRSTROW=2,
FIELDTERMINATOR=',',
TABLOCK
);
