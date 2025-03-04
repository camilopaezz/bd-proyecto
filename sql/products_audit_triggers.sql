-- Audit triggers for Products table

DELIMITER $$

-- Trigger for INSERT operations
CREATE TRIGGER products_insert_audit 
AFTER INSERT ON Products 
FOR EACH ROW 
BEGIN
    INSERT INTO Audit (table_name, action, record_id, description)
    VALUES (
        'Products',
        'INSERT',
        NEW.product_id,
        CONCAT('Added product: "', NEW.name, '" with ID ', NEW.product_id)
    );
END $$

-- Trigger for UPDATE operations
CREATE TRIGGER products_update_audit 
AFTER UPDATE ON Products 
FOR EACH ROW 
BEGIN
    INSERT INTO Audit (table_name, action, record_id, description)
    VALUES (
        'Products',
        'UPDATE',
        NEW.product_id,
        CONCAT('Updated product: "', NEW.name, '" with ID ', NEW.product_id)
    );
END $$

-- Trigger for DELETE operations
CREATE TRIGGER products_delete_audit 
AFTER DELETE ON Products 
FOR EACH ROW 
BEGIN
    INSERT INTO Audit (table_name, action, record_id, description)
    VALUES (
        'Products',
        'DELETE',
        OLD.product_id,
        CONCAT('Deleted product: "', OLD.name, '" with ID ', OLD.product_id)
    );
END $$

DELIMITER ;
