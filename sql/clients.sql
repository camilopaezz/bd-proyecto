create table
  Clients (
    client_id int auto_increment primary key,
    p_client_id varchar(36) null,
    name varchar(50) not null,
    phone varchar(10) not null,
    email varchar(20) not null,
    address varchar(100) not null
  );

-- Trigger to set a uuid for public usage
DELIMITER $$

CREATE TRIGGER before_insert_client 
BEFORE INSERT ON Clients 
FOR EACH ROW 
BEGIN 
    IF NEW.p_client_id IS NULL THEN
        SET NEW.p_client_id = UUID();
    END IF;
END $$

DELIMITER ;
