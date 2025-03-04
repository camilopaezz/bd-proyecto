-- Audit triggers for Orders table

DELIMITER $$

-- Trigger for INSERT operations
CREATE TRIGGER orders_insert_audit 
AFTER INSERT ON Orders 
FOR EACH ROW 
BEGIN
    INSERT INTO Audit (table_name, action, record_id, description)
    VALUES (
        'Orders',
        'INSERT',
        NEW.order_id,
        CONCAT('Created order with ID ', NEW.order_id, ' for client ID ', NEW.client_id)
    );
END $$

-- Trigger for UPDATE operations
CREATE TRIGGER orders_update_audit 
AFTER UPDATE ON Orders 
FOR EACH ROW 
BEGIN
    INSERT INTO Audit (table_name, action, record_id, description)
    VALUES (
        'Orders',
        'UPDATE',
        NEW.order_id,
        CONCAT('Updated order with ID ', NEW.order_id, ' for client ID ', NEW.client_id)
    );
END $$

-- Trigger for DELETE operations
CREATE TRIGGER orders_delete_audit 
AFTER DELETE ON Orders 
FOR EACH ROW 
BEGIN
    INSERT INTO Audit (table_name, action, record_id, description)
    VALUES (
        'Orders',
        'DELETE',
        OLD.order_id,
        CONCAT('Deleted order with ID ', OLD.order_id, ' for client ID ', OLD.client_id)
    );
END $$

DELIMITER ;
