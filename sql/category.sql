-- Create Table
create table Category (
    category_id int auto_increment primary key,
    description varchar(100) not null
)


DELIMITER //

-- Trigger for INSERT operations
CREATE TRIGGER category_insert_audit 
AFTER INSERT ON Category FOR EACH ROW
BEGIN
    INSERT INTO Audit (table_name, action, record_id, description)
    VALUES ('Category', 'INSERT', NEW.category_id, 
            CONCAT('Added category: "', NEW.description, '" with ID ', NEW.category_id));
END//

-- Trigger for UPDATE operations
CREATE TRIGGER category_update_audit
AFTER UPDATE ON Category FOR EACH ROW
BEGIN
    INSERT INTO Audit (table_name, action, record_id, description)
    VALUES ('Category', 'UPDATE', NEW.category_id,
            CONCAT('Updated category: "', NEW.description, '" with ID ', NEW.category_id));
END//

-- Trigger for DELETE operations
CREATE TRIGGER category_delete_audit
AFTER DELETE ON Category FOR EACH ROW
BEGIN
    INSERT INTO Audit (table_name, action, record_id, description)
    VALUES ('Category', 'DELETE', OLD.category_id,
            CONCAT('Deleted category: "', OLD.description, '" with ID ', OLD.category_id));
END//

DELIMITER ;
