create table
    Orders (
        order_id int auto_increment primary key,
        p_order_id varchar(36) null,
        client_id int not null,
        total float(2),
        quantity int unsigned not null,
        created_at datetime default CURRENT_TIMESTAMP,
        product_id int not null,
        foreign key (client_id) references Clients (client_id),
        foreign key (product_id) references Products (product_id)
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

-- Function to check if stock is available
CREATE FUNCTION fn_is_stock_available(p_product_id INT, p_quantity INT) 
RETURNS BOOLEAN
READS SQL DATA
BEGIN
    DECLARE available_stock INT;
    
    SELECT stock INTO available_stock 
    FROM Products 
    WHERE product_id = p_product_id;
    
    RETURN available_stock >= p_quantity;
END $$

-- Trigger to prevent orders with insufficient stock
CREATE TRIGGER tr_check_stock_before_order 
BEFORE INSERT ON Orders
FOR EACH ROW
BEGIN
    IF NOT fn_is_stock_available(NEW.product_id, NEW.quantity) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Insufficient stock available for this product';
    END IF;
END $$

-- Trigger to calculate total based on product price and quantity
CREATE TRIGGER tr_calculate_total_before_order
BEFORE INSERT ON Orders
FOR EACH ROW
BEGIN
    DECLARE product_price DECIMAL(10,2);
    
    SELECT price INTO product_price
    FROM Products
    WHERE product_id = NEW.product_id;
    
    SET NEW.total = product_price * NEW.quantity;
END $$

-- Trigger to update stock after order
CREATE TRIGGER tr_update_stock_after_order
AFTER INSERT ON Orders
FOR EACH ROW
BEGIN
    UPDATE Products
    SET stock = stock - NEW.quantity
    WHERE product_id = NEW.product_id;
END $$


DELIMITER ;
