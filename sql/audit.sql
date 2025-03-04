CREATE TABLE
  Audit (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    table_name VARCHAR(100) NOT NULL,
    action VARCHAR(10) NOT NULL,
    record_id INT NOT NULL,
    description VARCHAR(255) NOT NULL,
    user_id VARCHAR(50) NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  );