DELIMITER $$

-- Procedure to truncate Orders table
CREATE PROCEDURE sp_truncate_orders()
BEGIN
    SET FOREIGN_KEY_CHECKS = 0;
    TRUNCATE TABLE Orders;
    SET FOREIGN_KEY_CHECKS = 1;
    SELECT 'Orders table has been truncated' AS message;
END $$

-- Procedure to truncate Products table
CREATE PROCEDURE sp_truncate_products()
BEGIN
    SET FOREIGN_KEY_CHECKS = 0;
    TRUNCATE TABLE Products;
    SET FOREIGN_KEY_CHECKS = 1;
    SELECT 'Products table has been truncated' AS message;
END $$

-- Procedure to truncate Category table
CREATE PROCEDURE sp_truncate_category()
BEGIN
    SET FOREIGN_KEY_CHECKS = 0;
    TRUNCATE TABLE Category;
    SET FOREIGN_KEY_CHECKS = 1;
    SELECT 'Category table has been truncated' AS message;
END $$

-- Procedure to truncate Audit table
CREATE PROCEDURE sp_truncate_audit()
BEGIN
    TRUNCATE TABLE Audit;
    SELECT 'Audit table has been truncated' AS message;
END $$

-- Procedure to truncate Clients table
CREATE PROCEDURE sp_truncate_clients()
BEGIN
    SET FOREIGN_KEY_CHECKS = 0;
    TRUNCATE TABLE Clients;
    SET FOREIGN_KEY_CHECKS = 1;
    SELECT 'Clients table has been truncated' AS message;
END $$

-- Procedure to truncate Specs table
CREATE PROCEDURE sp_truncate_specs()
BEGIN
    SET FOREIGN_KEY_CHECKS = 0;
    TRUNCATE TABLE Specs;
    SET FOREIGN_KEY_CHECKS = 1;
    SELECT 'Specs table has been truncated' AS message;
END $$

-- Master procedure to truncate all tables in the correct order
CREATE PROCEDURE sp_truncate_all_tables()
BEGIN
    -- Disable foreign key checks for the entire operation
    SET FOREIGN_KEY_CHECKS = 0;
    
    -- First truncate tables with foreign keys (child tables)
    TRUNCATE TABLE Orders;
    TRUNCATE TABLE Products;
    
    -- Then truncate parent tables
    TRUNCATE TABLE Clients;
    TRUNCATE TABLE Category;
    TRUNCATE TABLE Specs;
    
    -- Finally truncate audit table
    TRUNCATE TABLE Audit;
    
    -- Re-enable foreign key checks
    SET FOREIGN_KEY_CHECKS = 1;
    
    SELECT 'All tables have been truncated' AS message;
END $$

DELIMITER ;