CREATE TABLE Audit (
  audit_id INT AUTO_INCREMENT PRIMARY KEY,
  table VARCHAR(100) NOT NULL,
  action VARCHAR(10) NOT NULL,
  register_id INT NOT NULL,
  data TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Orders

DELIMITER $$
CREATE TRIGGER orders_after_insert
AFTER INSERT ON Orders
FOR EACH ROW
BEGIN
    INSERT INTO auditoria (tabla, accion, registro_id, datos)
    VALUES (
      'Orders', 
      'INSERT', 
      NEW.order_id, 
      CONCAT('Inserted order with public id: ', NEW.p_order_id)
    );
END$$
DELIMITER ;