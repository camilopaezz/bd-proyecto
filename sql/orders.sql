create table
    Orders (
        order_id int auto_increment primary key,
        p_order_id varchar(36) null,
        client_id int not null,
        total float(2) not null,
        quantity int unsigned not null,
        created_at datetime default CURRENT_TIMESTAMP,
        product_id int not null,
        foreign key (client_id) references Clients (client_id),
        foreign key (product_id) references Products (product_id),
    );

DELIMITER $$

-- Trigger to set an uuid for public usage
CREATE TRIGGER before_insert_order
BEFORE INSERT ON Orders 
FOR EACH ROW 
BEGIN 
    IF NEW.p_order_id IS NULL THEN
        SET NEW.p_order_id = UUID();
    END IF;
END $$

DELIMITER ;
