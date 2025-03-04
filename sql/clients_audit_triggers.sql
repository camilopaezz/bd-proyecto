-- Audit triggers for Clients table

DELIMITER $$

-- Trigger for INSERT operations
CREATE TRIGGER clients_insert_audit 
AFTER INSERT ON Clients 
FOR EACH ROW 
BEGIN
    INSERT INTO Audit (table_name, action, record_id, description)
    VALUES (
        'Clients',
        'INSERT',
        NEW.client_id,
        CONCAT('Added client: "', NEW.name, '" with ID ', NEW.client_id)
    );
END $$

-- Trigger for UPDATE operations
CREATE TRIGGER clients_update_audit 
AFTER UPDATE ON Clients 
FOR EACH ROW 
BEGIN
    INSERT INTO Audit (table_name, action, record_id, description)
    VALUES (
        'Clients',
        'UPDATE',
        NEW.client_id,
        CONCAT('Updated client: "', NEW.name, '" with ID ', NEW.client_id)
    );
END $$

-- Trigger for DELETE operations
CREATE TRIGGER clients_delete_audit 
AFTER DELETE ON Clients 
FOR EACH ROW 
BEGIN
    INSERT INTO Audit (table_name, action, record_id, description)
    VALUES (
        'Clients',
        'DELETE',
        OLD.client_id,
        CONCAT('Deleted client: "', OLD.name, '" with ID ', OLD.client_id)
    );
END $$

DELIMITER ;
